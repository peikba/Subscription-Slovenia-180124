page 50103 "CSD Subscription FactBox"
{
    PageType = ListPart;
    SourceTable = "CSD Customer Subscription";
    Editable = false;
    Caption = 'Subscriptions';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer No.';
                    Visible = ShowCustomerNo;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item No.';
                    Visible = ShowItemNo;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Start Date';
                }
                field("Cancelled Date"; Rec."Cancelled Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Cancelled Date';
                }
            }
        }
    }
    var
        ShowCustomerNo: Boolean;
        ShowItemNo: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.FilterGroup(4);
        ShowCustomerNo := (Rec.GetFilter("Customer No.") = '');
        ShowItemNo := (Rec.GetFilter("Item No.") = '');
        Rec.FilterGroup(0);
    end;
}
