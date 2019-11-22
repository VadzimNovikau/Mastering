public class OrdersController {
    public List<Orders__c> ordersList {get; set;}
    public Orders__c ord {get; set;}
    public String sortDirection {get; set;}
    public String orderId {get; set;}
    public String closeNewButton {get; set;}
    public String searchString {get;set;}
    public List<Delivery_type__c> deliveryTypes{get; set;}
    public Delivery_type__c dType {get; set;}
    public Boolean showForm {get; set;}
        
    public OrdersController(){
        loadData();
        deliveryTypes = getDeliveryTypes();
        ord = new Orders__c();
        closeNewButton = Label.New;
    }
                                       
    private List<Delivery_type__c> getDeliveryTypes(){
        List<Delivery_type__c> listTypes = [SELECT Id, Name FROM Delivery_type__c];
        return listTypes;
    }
    
    private void loadData() {
        sortDirection = ' ASC ';
        String query = 'SELECT id, Name, Weight__c, Price__c, Delivery_date__c FROM Orders__c ORDER by Name ' + sortDirection;
        ordersList = Database.query(query);
    }
    
    public List<SelectOption> getselectValues() {
        List<SelectOption> options = new List<SelectOption>();
        for (Delivery_type__c dt : deliveryTypes) {
            options.add(new SelectOption(dt.Id, dt.Name));
        }  
        return options;
    }
    
    public void information(){
        dType = [SELECT Id, Name, Max_weight__c, Price_shipping_1_kg__c, Delivery_days__c FROM Delivery_type__c WHERE id =: ord.Delivery_type__c];
    }
    
    public void save(){
        system.debug('ID'+ ord.Delivery_type__c);
        if (ord.Name == '') {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Field "Delivery by" is required!'));}
           else
               {
               if (ord.Weight__c < 0) {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Check the data is filled in correctly!'));}
                  else {
                          upsert ord;
                          ord = new Orders__c();
                          dType = null;
                          loadData();
                       }
           } 
    }
  
    public void editOrder() {
        ord = [SELECT id, Name, Weight__c, Price__c, Delivery_date__c, Delivery_type__c FROM Orders__c WHERE Id = :orderId];
        showForm = true;
        closeNewButton = Label.Close_form;
    }
    
    public void deleteOrder() {
        delete [SELECT Id  FROM Orders__c WHERE Id = :orderId];
        loadData();
    }
    
    public void clear() {
      ord = new Orders__c();
      searchstring = '';
      loadData();
    }
    
    public void show() {
        ord = new Orders__c();
        if (showForm == true) {
         showForm = false;
         closeNewButton = Label.New;
        } else
         {
          showForm = true;
          closeNewButton = Label.Close_form;
         }
    }
    
    public void sortWeightColumn() {
        sortDirection = (sortDirection == ' ASC ')? ' DESC ' : ' ASC '; 
        String query = 'SELECT id, Name, Weight__c, Price__c, Delivery_date__c FROM Orders__c ORDER by Weight__c ' + sortDirection + 'NULLS LAST';
        ordersList = Database.query(query);
    }
    
    public void sortPriceColumn() {
        sortDirection = (sortDirection == ' ASC ')? ' DESC ' : ' ASC ';
        String query = 'SELECT id, Name, Weight__c, Price__c, Delivery_date__c FROM Orders__c ORDER by Price__c ' + sortDirection + 'NULLS LAST';
        ordersList = Database.query(query);
    }
    
    public void sortDateColumn() {
        sortDirection = (sortDirection == ' ASC ')? ' DESC ' : ' ASC ';
        String query = 'SELECT id, Name, Weight__c, Price__c, Delivery_date__c FROM Orders__c ORDER by Delivery_date__c ' + sortDirection + 'NULLS LAST';
        ordersList = Database.query(query);
    }
    
    public void sortNameColumn() {
        sortDirection = (sortDirection == ' ASC ')? ' DESC ' : ' ASC ';
        String query = 'SELECT id, Name, Weight__c, Price__c, Delivery_date__c FROM Orders__c ORDER by Name ' + sortDirection + 'NULLS LAST';
        ordersList = Database.query(query);
    }
    
    public static Date isValidDate(String dateString) {
        try{
            Date.parse(dateString);
            return Date.parse(dateString);
        } catch (Exception e){
            return null;
            }
    }
    
    public static Double isNumber(String intString) {
        try{
            Double.valueof(intString);
            return Double.valueof(intString);
        } catch (Exception e){
            return null;
            }
    }
    
    public void searchRecord(){ 
     Date paramDate = isValidDate(searchString);
     String nameSegmentSoql = '%' + searchString.replaceAll('\'', '') + '%';
     Double isNum = isNumber(searchString);
       
            ordersList = [SELECT id, Name, Weight__c, Price__c, Delivery_date__c
                    FROM Orders__c
                    WHERE Name LIKE : nameSegmentSoql OR Price__c = : isNum OR Weight__c = : isNum OR Delivery_date__c = : paramDate];
               
    }
}