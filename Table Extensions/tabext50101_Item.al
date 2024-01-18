tableextension 50101 "CSD Item" extends Item
{
    fields
    {
        field(50100; "CSD Subscription Item"; Boolean)
        {
            Caption = 'Subscription Item';
            FieldClass = FlowField;
            CalcFormula = exist("CSD Customer Subscription" where("Item No." = field("No."), Active = const(true)));
            Editable=false;
        }
    }
}