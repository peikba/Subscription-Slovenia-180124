pageextension 50101 "CSD Customer List" extends "Customer List"
{
    layout
    {
        addlast(Control1)
        {
            field("CSD Subscription Customer"; Rec."CSD Subscription Customer")
            {
                ApplicationArea = All;
                ToolTip = 'CSD Subscription Customer';
            }
        }
        addfirst(factboxes)
        {
            part("CSD Subscription FactBox"; "CSD Subscription FactBox")
            {
                SubPageLink = "Customer No." = field("No.");
            }
        }
    }

    actions
    {
        addfirst(processing)
        {
            action(Subscriptions)
            {
                ApplicationArea = All;
                Caption = '&Subscriptions';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = InsuranceRegisters;
                RunObject = page "CSD Customer Subscriptions";
                RunPageLink = "Customer No." = field("No.");
                ToolTip = 'Subscriptions';
            }
        }
    }
}