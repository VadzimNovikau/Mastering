public class OrdersControllerForPDF {
    public Id reportId {get; set;}
    
    public List<Delivery_type__c> deliveryTypes {
        get {
            return [
            SELECT Id, Name, Max_weight__c, Price_shipping_1_kg__c, Delivery_days__c 
            FROM Delivery_type__c 
            WHERE Id IN (SELECT Delivery_type__c FROM Orders__c)
            ];
        }
        set;
    }
    
    public List<Orders__c> ordersList {
        get {
            if (ordersList == null) {
                ordersList = [
                    SELECT id, Name, Weight__c, Price__c, Delivery_date__c, Delivery_type__r.Name 
                    FROM Orders__c 
                    WHERE Delivery_type__c =: reportId
                ];
            }
            return ordersList;
        }
        set;
    }
}