pageextension 50104 "CSD Item List" extends "Item List"
{
    layout
    {
        addlast(Control1)
        {
            field("CSD Subscription Item"; Rec."CSD Subscription Item")
            {
                ApplicationArea = All;
                ToolTip = 'CSD Subscription Item';
            }
        }
        addfirst(factboxes)
        {
            part("CSD Subscription FactBox"; "CSD Subscription FactBox")
            {
                SubPageLink = "Item No." = field("No.");
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
                RunPageLink = "Item No." = field("No.");
                ToolTip = 'Subscriptions';
            }
        }
    }
}