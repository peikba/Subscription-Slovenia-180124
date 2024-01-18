codeunit 50100 "CSD Event Subscriptions"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', true, true)]
    local procedure UpdateSubscriptionsOnAfterPostSalesDoc(SalesInvHdrNo: Code[20])
    var
        SalesInvLine: Record "Sales Invoice Line";
        CustomerSubscription: Record "CSD Customer Subscription";
        Subscription: Record "CSD Subscription";
    begin
        SalesInvLine.SetRange("Document No.", SalesInvHdrNo);
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        if SalesInvLine.FindSet() then
            repeat
                CustomerSubscription.SetRange("Item No.", SalesInvLine."No.");
                CustomerSubscription.SetRange("Customer No.", SalesInvLine."Sell-to Customer No.");
                CustomerSubscription.SetRange(Active, true);
                if CustomerSubscription.FindFirst() then begin
                    Subscription.Get(CustomerSubscription."Subscription Code");
                    CustomerSubscription."Last Invoice Date" := SalesInvLine."Posting Date";
                    CustomerSubscription."Next Invoice Date" := CalcDate(Subscription."Invoicing Frequence", CustomerSubscription."Last Invoice Date");
                    CustomerSubscription.Modify();
                end;
            until SalesInvLine.Next() = 0;
    end;
}