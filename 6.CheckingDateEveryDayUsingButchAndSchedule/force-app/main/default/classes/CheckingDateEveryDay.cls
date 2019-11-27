global class CheckingDateEveryDay implements
    Database.Batchable<sObject>, Database.Stateful {
        global Integer recordsProcessed = 0;
        global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT ID, Name, Delivery_date__c, Delivery_type__c, Expired__c  FROM Orders__c ');
    }

    global void execute(Database.BatchableContext bc, List<Orders__c> listOrders) {
        for (Orders__c order : listOrders) {
            if (order.Delivery_date__c < Date.today()) {
                order.Expired__c = true;
                recordsProcessed = recordsProcessed + 1;
            }
        }
        update listOrders;
    } 
        
    global void finish(Database.BatchableContext bc) {
        User userForMassege = [
            SELECT Id, Name, Email 
            FROM User 
            WHERE Id =: UserInfo.getUserId() LIMIT 1
            ];

        AsyncApexJob job = [
            SELECT Id, CompletedDate 
            FROM AsyncApexJob 
            WHERE Id = :bc.getJobId()
            ];

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		email.setToAddresses(new List<String> {userForMassege.Email});
		email.setPlainTextBody('Dear ' + userForMassege.Name + ' ' + recordsProcessed + 'orders with an expired delivery time were processed at the ' + job.CompletedDate);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
	}
}