public class DeliveryWeightTrHelper {
    public static void processingWeight(List<Orders__c>orders) {
        List<Delivery_type__c> deliveryTypes = [
            SELECT id, Name, Max_weight__c, Delivery_days__c 
            FROM Delivery_type__c
        ];
        for (Orders__c order : orders) {
            String orderName = order.Delivery_type__c;
            for (Delivery_type__c dT : deliveryTypes) {
                if (dT.id == orderName) {
                    Double weightFull = dT.Max_weight__c;
                    Double deliveryDays = dT.Delivery_days__c;
                    if (order.Weight__c > weightFull){
                        Double orderWeight = order.Weight__c;
                        Double daysAdd = orderWeight*deliveryDays/weightFull-deliveryDays;
                        if ((daysAdd-(Integer)daysAdd) == 0) {
                            order.Delivery_date__c = order.Delivery_date__c + (Integer)daysAdd; 
                        }
                        else {
                            order.Delivery_date__c = order.Delivery_date__c + (Integer)daysAdd + 1;
                        }
                    }
                }    
            }     
        }
    }

    public static void sendMessageWithOrder(List<Orders__c> newOrder) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate = [
            Select Id, Name
            FROM EmailTemplate
            WHERE Name = 'CreateNewOrder'
        ];
        for (Orders__c order : newOrder) {
            if (order.Delivery_type__c != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(UserInfo.getUserId());
                mail.setUseSignature(false); 
                mail.setBccSender(false); 
                mail.setSaveAsActivity(false);
                mail.setTemplateId(emailTemplate.Id);
                mail.setWhatId(order.Id);
                emails.add(mail);
            }
            if (emails.size() > 0) {
                Messaging.sendEmail(emails);
            }
        }
    }
}