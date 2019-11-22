public class FillingMobileOperatorInContactTrHelper {
      public static void checkingProcess (List <Contact> newContacts){
          
         List<Mobile_Operator_Code__mdt> mobileOperatorCodes = [Select Id, Label, Phone_Number_Code__c From Mobile_Operator_Code__mdt];
          
          for (Contact cont : newContacts){
              String phoneNumber = cont.MobilePhone;
                 if (phoneNumber != null && Pattern.matches('.+375-[0-9]{2}-[0-9]{7}', phoneNumber)){
                     String[] subStr = phoneNumber.split('-');
                    // if (subStr.size() > 2){
                       String code = subStr[1];
                       for (Mobile_Operator_Code__mdt moc : mobileOperatorCodes){
                          if (moc.Phone_Number_Code__c == code){
                             cont.Mobile_Operator__c = moc.Label;
                          } 
                       }
                     //}
                 }    
          }
          
      }
}