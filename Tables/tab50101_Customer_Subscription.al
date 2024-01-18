table 50101 "CSD Customer Subscription"
{
    Caption = 'Customer Subscription';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(2; "Subscription Code"; Code[10])
        {
            Caption = 'Subscription Code';
            DataClassification = CustomerContent;
            TableRelation = "CSD Subscription";
            trigger OnValidate()
            var
                Subscription: Record "CSD Subscription";
                Item: Record Item;
            begin
                //If the subscription Code is changed, test that the Last Invoice Date is empty
                if Rec."Subscription Code" <> xRec."Subscription Code" then
                    TestField("Last Invoice Date", 0D);

                if Subscription.Get("Subscription Code") then begin
                    //On the selected subscription record, test that the following fields are not empty
                    Subscription.TestField("Item Number");
                    Subscription.TestField("Invoicing Frequence");

                    //Depending on Subscription."Invoicing Schedule" set the start date
                    case Subscription."Invoicing Schedule" of
                        Subscription."Invoicing Schedule"::"Beginning of Next Period":
                            "Start Date" := CalcDate('<CM+1D>', WorkDate());
                        Subscription."Invoicing Schedule"::"Beginning of Period":
                            "Start Date" := CalcDate('<-CM>', WorkDate());
                        Subscription."Invoicing Schedule"::"End of Period":
                            "Start Date" := CalcDate('<CM>', WorkDate());
                        Subscription."Invoicing Schedule"::"Posting Date":
                            "Start Date" := WorkDate();
                    end
                end else
                    "Start Date" := 0D;

                //Then set the item no from the subscription record
                "Item No." := Subscription."Item Number";

                //Set the Invoicing Price from the subscription record or from the item record if the Invoicing Price on the subscription is empty
                if Subscription."Invoicing Price" <> 0 then
                    "Invoicing Price" := Subscription."Invoicing Price"
                else
                    if Item.get("Item No.") then
                        "Invoicing Price" := item."Unit Price"
                    else
                        "Invoicing Price" := 0;
            end;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(4; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        }
        field(5; "Last Invoice Date"; Date)
        {
            Caption = 'Last Invoice Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Next Invoice Date"; Date)
        {
            Caption = 'Next Invoice Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Cancelled Date"; Date)
        {
            Caption = 'Cancelled Date';
            DataClassification = ToBeClassified;
        }
        field(8; Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
        }
        field(9; "Invoicing Price"; Decimal)
        {
            Caption = 'Invoicing Price';
            DataClassification = CustomerContent;
        }
        field(10; "Allow Line Discount"; Boolean)
        {
            Caption = 'Allow Line Discount';
            DataClassification = CustomerContent;
        }
    }


    keys
    {
        key(Key1; "Customer No.", "Subscription Code")
        {
            Clustered = true;
        }
    }
}