@isTest
public class TestTrigger {
    
    @isTest
    static void processingWeightTest() {
        Delivery_type__c deliveryType = new Delivery_type__c(Name = 'TestDeliveryType', Max_weight__c = 100, Price_shipping_1_kg__c = 5, Delivery_days__c = 10);
        insert deliveryType;
        
        List<Delivery_type__c> deliveryTypes = [SELECT id, Name, Max_weight__c, Delivery_days__c FROM Delivery_type__c];
          
        Orders__c order1 = new Orders__c(Name = 'TestOrder1', Weight__c = 10, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 09, 25));
        insert order1;
        Orders__c order2 = new Orders__c(Name = 'TestOrder2',  Weight__c = 120, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 09, 25));
        insert order2;
        Orders__c order3 = new Orders__c(Name = 'TestOrder3',  Weight__c = 155, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 09, 25));
        insert order3;
        
        List<Orders__c> orders = [SELECT id, Name, Weight__c, Price__c, Delivery_date__c FROM Orders__c ORDER by Name];
                
        System.assertEquals(Date.newInstance(2019, 09, 25), orders[0].Delivery_date__c);
        System.assertEquals(Date.newInstance(2019, 09, 27), orders[1].Delivery_date__c);
        System.assertEquals(Date.newInstance(2019, 10, 01), orders[2].Delivery_date__c);
       
    }

}