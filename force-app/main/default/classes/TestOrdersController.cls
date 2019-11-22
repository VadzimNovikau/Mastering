@isTest
public class TestOrdersController {
    
    public static OrdersController ordContr(String name, Double weight, Date delivDate) {
        OrdersController ordContr = new OrdersController();
        ordContr.ord.Name = name;
        ordContr.ord.Weight__c = weight;
        ordContr.ord.Delivery_date__c = delivDate;
        ordContr.save();
        return ordContr;
    }
    
    @isTest
    static void saveCorrectOrder() {
        OrdersController ordContr = new OrdersController();
        ordContr('Name', 5, Date.today());
        System.assertEquals(1, [SELECT count() FROM Orders__c]);
    }
    
    @isTest
    static void saveIncorrectOrderName() {
        ordContr('', 5, Date.today());
        System.assertEquals(0, [SELECT count() FROM Orders__c]);
        List<ApexPages.Message> msgListName = ApexPages.getMessages();
        for(ApexPages.Message msgName :  ApexPages.getMessages()) {
             System.assertEquals('Field "Delivery by" is required!', msgName.getSummary());
             System.assertEquals(ApexPages.Severity.ERROR, msgName.getSeverity()); 
        }
    }
    
    @isTest
    static void saveIncorrectOrderWeight() {                          
        ordContr('Name', -5, Date.today());
        System.assertEquals(0, [SELECT count() FROM Orders__c]);
        List<ApexPages.Message> msgListWeight = ApexPages.getMessages();
        for(ApexPages.Message msgWeight :  ApexPages.getMessages()) {
             System.assertEquals('Check the data is filled in correctly!', msgWeight.getSummary());
             System.assertEquals(ApexPages.Severity.ERROR, msgWeight.getSeverity()); 
        }
    }
    
    @isTest
    static void sortbyName() {
        List<Orders__c> ordersList = new List<Orders__c>();
        Orders__c order1 = new Orders__c(Name = 'aaa', Weight__c = 5, Delivery_date__c = Date.newInstance(2019, 09, 25));
        ordersList.add(order1);
        Orders__c order2 = new Orders__c(Name = 'bbb',  Weight__c = 10, Delivery_date__c = Date.newInstance(2019, 09, 26));
        ordersList.add(order2);
        Orders__c order3 = new Orders__c(Name = 'ccc',  Weight__c = 15, Delivery_date__c = Date.newInstance(2019, 09, 27));
        ordersList.add(order3);
        insert ordersList;
        
        OrdersController ordContr = new OrdersController();
        ordContr.sortDirection = 'ASC';
        ordContr.sortNameColumn();
        System.assertEquals('aaa', ordContr.ordersList[0].Name);
        ordContr.sortNameColumn();
        System.assertEquals('ccc', ordContr.ordersList[0].Name);
    }
    
    @isTest
    static void sortbyWeight() {
        List<Orders__c> ordersList = new List<Orders__c>();
        Orders__c order1 = new Orders__c(Name = 'Name', Weight__c = 5, Delivery_date__c = Date.newInstance(2019, 09, 25));
        ordersList.add(order1);
        Orders__c order2 = new Orders__c(Name = 'Name',  Weight__c = 10, Delivery_date__c = Date.newInstance(2019, 09, 26));
        ordersList.add(order2);
        Orders__c order3 = new Orders__c(Name = 'Name',  Weight__c = 15, Delivery_date__c = Date.newInstance(2019, 09, 27));
        ordersList.add(order3);
        insert ordersList;
        
        OrdersController ordContr = new OrdersController();
        ordContr.sortDirection = 'ASC';
        ordContr.sortWeightColumn();
        System.assertEquals(5, ordContr.ordersList[0].Weight__c);
        ordContr.sortWeightColumn();
        System.assertEquals(15, ordContr.ordersList[0].Weight__c);
    }
    
    @isTest
    static void sortbyPrice() {
        Delivery_type__c deliveryType = new Delivery_type__c(Name = 'TestDeliveryType', Max_weight__c = 100, Price_shipping_1_kg__c = 5, Delivery_days__c = 10);
        insert deliveryType;
        List<Orders__c> ordersList = new List<Orders__c>();
        Orders__c order1 = new Orders__c(Name = 'TestOrder1', Weight__c = 5, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 09, 25));
        ordersList.add(order1);
        Orders__c order2 = new Orders__c(Name = 'TestOrder2',  Weight__c = 10, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 09, 25));
        ordersList.add(order2);
        Orders__c order3 = new Orders__c(Name = 'TestOrder3',  Weight__c = 15, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 09, 25));
        ordersList.add(order3);
        insert ordersList;
        
        OrdersController ordContr = new OrdersController();
        ordContr.sortDirection = 'ASC';
        ordContr.sortPriceColumn();
        System.assertEquals(25, ordContr.ordersList[0].Price__c);
        System.assertEquals(50, ordContr.ordersList[1].Price__c);
        System.assertEquals(75, ordContr.ordersList[2].Price__c);
        ordContr.sortPriceColumn();
        System.assertEquals(75, ordContr.ordersList[0].Price__c);
        System.assertEquals(50, ordContr.ordersList[1].Price__c);
        System.assertEquals(25, ordContr.ordersList[2].Price__c);
   }
   
    @isTest
    static void sortbyDate() {
        List<Orders__c> ordersList = new List<Orders__c>();
        Orders__c order1 = new Orders__c(Name = 'Name', Weight__c = 5, Delivery_date__c = Date.newInstance(2019, 09, 25));
        ordersList.add(order1);
        Orders__c order2 = new Orders__c(Name = 'Name',  Weight__c = 10, Delivery_date__c = Date.newInstance(2019, 10, 26));
        ordersList.add(order2);
        Orders__c order3 = new Orders__c(Name = 'Name',  Weight__c = 15, Delivery_date__c = Date.newInstance(2019, 11, 27));
        ordersList.add(order3);
        insert ordersList;
        
        OrdersController ordContr = new OrdersController();
        ordContr.sortDirection = 'ASC';
        ordContr.sortDateColumn();
        System.assertEquals(Date.newInstance(2019, 09, 25), ordContr.ordersList[0].Delivery_date__c);
        ordContr.sortDateColumn();
        System.assertEquals(Date.newInstance(2019, 11, 27), ordContr.ordersList[0].Delivery_date__c);
    }
    
    @isTest
    static void seach() {
        Delivery_type__c deliveryType = new Delivery_type__c(Name = 'TestDeliveryType', Max_weight__c = 100, Price_shipping_1_kg__c = 5, Delivery_days__c = 10);
        insert deliveryType;
        List<Orders__c> ordersList = new List<Orders__c>();
        Orders__c order1 = new Orders__c(Name = 'NameOld', Weight__c = 5, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 11, 15));
        ordersList.add(order1);
        Orders__c order2 = new Orders__c(Name = 'NameseachName',  Weight__c = 15, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 11, 25));
        ordersList.add(order2);
        Orders__c order3 = new Orders__c(Name = 'Nameseach',  Weight__c = 1005, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 11, 10));
        ordersList.add(order3);
        Orders__c order4 = new Orders__c(Name = 'seachName',  Weight__c = 5, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 10, 15));
        ordersList.add(order4);
        Orders__c order5 = new Orders__c(Name = 'Name',  Weight__c = 34, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 05, 15));
        ordersList.add(order5);
        Orders__c order6 = new Orders__c(Name = 'Name34',  Weight__c = 134, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 12, 25));
        ordersList.add(order6);
        insert ordersList;
        
        OrdersController ordContr = new OrdersController();
        ordContr.searchString = 'seach';
        ordContr.searchRecord();
        System.assertEquals(3, ordContr.ordersList.size());
        System.assertEquals('NameseachName', ordContr.ordersList[0].Name);
        System.assertEquals('Nameseach', ordContr.ordersList[1].Name);
        System.assertEquals('seachName', ordContr.ordersList[2].Name);
        
        ordContr.searchString = '5';
        ordContr.searchRecord();
        System.assertEquals(2, ordContr.ordersList.size());
        System.assertEquals(5, ordContr.ordersList[0].Weight__c);
        System.assertEquals(5, ordContr.ordersList[1].Weight__c);
        
        ordContr.searchString = '34';
        ordContr.searchRecord();
        System.assertEquals(2, ordContr.ordersList.size());
        System.assertEquals('Name34', ordContr.ordersList[1].Name);
        System.assertEquals(34, ordContr.ordersList[0].Weight__c);
        
        ordContr.searchString = '11/15/2019';
        ordContr.searchRecord();
        System.assertEquals(1, ordContr.ordersList.size());
        System.assertEquals(Date.newInstance(2019, 11, 15), ordContr.ordersList[0].Delivery_date__c);
        
        ordContr.searchString = '25';
        ordContr.searchRecord();
        System.assertEquals(2, ordContr.ordersList.size());
        System.assertEquals(25, ordContr.ordersList[0].Price__c);
        System.assertEquals(25, ordContr.ordersList[1].Price__c);
    }
    
    @isTest
    static void getselectValues() {
        OrdersController ordContr = new OrdersController();
        List<SelectOption> options = ordContr.getselectValues();
        System.debug(ordContr.getselectValues());
        System.assertEquals([SELECT count() FROM Delivery_type__c], ordContr.getselectValues().size());
    }
    
    @isTest
    static void clear() {
        OrdersController ordContr = new OrdersController();
        ordContr('NameseachName', 5, Date.newInstance(2019, 11, 15));
        ordContr('Nameseach', 534, Date.newInstance(2019, 11, 25));
        ordContr('Name',10005, Date.newInstance(2019, 11, 10));
        ordContr.searchString = 'seach';
        ordContr.searchRecord();
        System.assertEquals(2, ordContr.ordersList.size());
        
        ordContr.searchString = '';
        ordContr.clear();
        System.assertEquals(3, ordContr.ordersList.size());
    }
    
    @isTest
    static void del() {
        Orders__c A = new Orders__c(Name = 'Name');
        insert A;
        System.assertEquals(1, [SELECT count() FROM Orders__c]);
        OrdersController ordContr = new OrdersController();
        ordContr.orderId = A.Id;
        ordContr.deleteOrder();
        System.assertEquals(0, [SELECT count() FROM Orders__c]);
    }  
    
    @isTest
    static void information() {
        Delivery_type__c deliveryType = new Delivery_type__c(Name = 'Type', Max_weight__c = 100, Price_shipping_1_kg__c = 5, Delivery_days__c = 10);
        insert deliveryType;
        Id idType = deliveryType.Id;
 
        OrdersController ordContr = new OrdersController();
        ordContr.ord.Delivery_type__c = idType;
        ordContr.information();
        System.assertEquals('Type', ordContr.dType.Name);
        System.assertEquals(100, ordContr.dType.Max_weight__c);
        System.assertEquals(5, ordContr.dType.Price_shipping_1_kg__c);
        System.assertEquals(10, ordContr.dType.Delivery_days__c);
    }  
    
    @isTest
    static void ShowAndClose() {
        OrdersController ordContr = new OrdersController();
        ordContr.showForm = true;
        ordContr.Show();
        System.assertEquals(false, ordContr.showForm);
        ordContr.Show();
        System.assertEquals(true, ordContr.showForm);
    }
    
    @isTest
    static void editOrder() {
        Delivery_type__c deliveryType = new Delivery_type__c(Name = 'TestDeliveryType', Max_weight__c = 100, Price_shipping_1_kg__c = 5, Delivery_days__c = 10);
        insert deliveryType;
        List<Orders__c> ordersList = new List<Orders__c>();
        Orders__c order1 = new Orders__c(Name = 'Name1', Weight__c = 5, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 11, 15));
        ordersList.add(order1);
        Orders__c order2 = new Orders__c(Name = 'Name2',  Weight__c = 15, Delivery_type__c = deliveryType.Id, Delivery_date__c = Date.newInstance(2019, 11, 25));
        ordersList.add(order2);
        insert ordersList;
        OrdersController ordContr = new OrdersController();
        ordContr.orderId = order1.id;
        ordContr.editOrder();
        System.assertEquals(ordContr.ord.id, order1.id);
        System.assertEquals(ordContr.ord.Name, order1.Name);
        System.assertEquals(ordContr.ord.Weight__c, order1.Weight__c);
        System.assertEquals(ordContr.ord.Delivery_type__c, order1.Delivery_type__c);
        System.assertEquals(ordContr.ord.Delivery_date__c, order1.Delivery_date__c);
    }
          
}