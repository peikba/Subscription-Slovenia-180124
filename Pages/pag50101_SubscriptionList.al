page 50101 "CSD Subscription List"
{
    Caption = 'Subscription List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Subscription";
    CardPageId = "CSD Subscription Card";
    Editable=false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Code';
                }
                field("Name"; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name';
                }
                field("Item No"; Rec."Item Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item No.';
                }
                field("Invoicing Schedule"; Rec."Invoicing Schedule")
                {
                    ApplicationArea = All;
                    ToolTip = 'Invoicing Schedule';
                }
                field("Invoicing Frequency"; Rec."Invoicing Frequence")
                {
                    ApplicationArea = All;
                    ToolTip = 'Invoicing Frequency';
                }
                field("Invoicing Price"; Rec."Invoicing Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Invoicing Price';
                }

            }
        }
    }
}