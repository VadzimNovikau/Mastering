public class GiftsForUsersOrProfilesTrHelper {
    public static void checkingProcess (List <Gift__c> newGifts){
        for (Gift__c gift : newGifts){
            id idUser = gift.Gift_Recipient__c;
            Gifts__c present = Gifts__c.getInstance(idUser);
            gift.Gift_Description__c = present.Gift__c;
        }
    }
}