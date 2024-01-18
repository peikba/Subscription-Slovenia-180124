report 50100 "CSD Create Subscrip. Invoices"
{
    Caption = 'Create Subscription Invoices';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;


    dataset
    {
        dataitem("CSD Customer Subscription"; "CSD Customer Subscription")
        {
            DataItemTableView = sorting("Customer No.", "Subscription Code") where(Active = const(true));
            RequestFilterFields = "Customer No.", "Item No.";

            trigger OnPreDataItem()
            begin
                SetFilter("Next Invoice Date", '<=%1', EndingDate);
            end;

            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;
            begin
                if not not SubscriptionInvoiceExists("Customer No.", "Item No.", "Next Invoice Date") then begin

                    if ("Customer No." <> Customer."No.") then begin
                        Customer.Get("Customer No.");
                        InsertSalesHeader("Customer No.", "Next Invoice Date");
                    end;
                    InsertSalesLine("Item No.", 1, "Invoicing Price", "Allow Line Discount");
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(EndingDate2; EndingDate)
                    {
                        Caption = 'Create Invoiced up until Date';
                        ApplicationArea = All;
                        ToolTip = 'Create Invoiced up until Date';
                    }
                }
            }
        }

    }
    trigger OnPreReport()
    var
        RunWarningLbl: Label 'This report will create invoices for all active customers with a subscription Due. Do you want to continue?';
    begin
        if not Confirm(RunWarningLbl, false) then
            CurrReport.Quit();
        EndingDate := CalcDate('<CM>', workdate());
    end;

    trigger OnPostReport()
    var
        CreatedLbl: Label 'Created %1 invoices', Comment = '%1 = Number of invoices created';
    begin
        Message(CreatedLbl, CreateCounter);
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        EndingDate: Date;
        NextLineNo: Integer;
        CreateCounter: Integer;

    local procedure InsertSalesHeader(inCustomerNo: Code[20]; inStartingDate: Date)
    begin
        Clear(SalesHeader);
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", inCustomerNo);
        SalesHeader.Validate("Posting Date", inStartingDate);
        SalesHeader.Validate("Location Code", '');
        SalesHeader.Modify();
        NextLineNo := 10000;
        CreateCounter += 1;
    end;

    local procedure InsertSalesLine(inItemNo: Code[20]; inQuantity: Decimal; inUnitPrice: Decimal; inAllowLineDiscount: Boolean)
    begin
        SalesLine.Init();
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine.Validate("Line No.", NextLineNo);
        SalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        SalesLine.insert(true);
        SalesLine.Validate("Type", SalesLine.Type::Item);
        SalesLine.Validate("No.", inItemNo);
        SalesLine.Validate("Allow Line Disc.", inAllowLineDiscount);
        SalesLine.Validate("Quantity", inQuantity);
        SalesLine.Validate("Unit Price", inUnitPrice);
        SalesLine.Modify();
        NextLineNo += 10000;
    end;


    local procedure SubscriptionInvoiceExists(inCustomerNo: Code[20]; InItemNo: Code[20]; inStartDate: date): Boolean
    var
        TestSalesLine: Record "Sales Line";
    begin
        TestSalesLine.SetRange("Sell-to Customer No.", inCustomerNo);
        TestSalesLine.SetRange("Type", TestSalesLine.Type::Item);
        TestSalesLine.SetRange("No.", InItemNo);
        TestSalesLine.SetRange("Posting Date", inStartDate);
        TestSalesLine.SetRange("Document Type", TestSalesLine."Document Type"::Invoice);
        exit(not TestSalesLine.IsEmpty());
    end;
}