@isTest
public class CheckingDateEveryDayBatchTest {
    @testSetup 
    static void checkList(){
        List<Orders__c> ordersList = new List<Orders__c>();
        Orders__c order1 = new Orders__c(Name = 'aaa', Delivery_date__c = Date.today()-1);
        ordersList.add(order1);
        Orders__c order2 = new Orders__c(Name = 'bbb',  Delivery_date__c = Date.today()-2);
        ordersList.add(order2);
        Orders__c order3 = new Orders__c(Name = 'ccc',  Delivery_date__c = Date.today()+1);
        ordersList.add(order3);
        insert ordersList;
    }

    @isTest
    static void checkProcessor() {
       Test.startTest();
       Id batchId = Database.executeBatch(new CheckingDateEveryDay());
       Test.stopTest();
       List<Orders__c> ordersForChecking = [
            SELECT Id, Expired__c 
            FROM Orders__c 
            WHERE Expired__c = true
        ];
       System.assertEquals(2, ordersForChecking.size());

    }    
}