public class CheckingEmaiContactTrHelper {
    public static void checkingProcess (List<Contact> newContacts){
        AccountLinking__c alFilled = AccountLinking__c.getValues('FilledContactEmail');
        AccountLinking__c alMissed = AccountLinking__c.getValues('MissedContactEmail'); 
        if (newContacts.size()==1 && alFilled !=null && alMissed != null){
            Contact con = newContacts[0];
            if(con.Email != null){
                if (con.AccountId == null){
                    con.AccountId = alFilled.DefaultAccountId__c;
                } else if (con.AccountId != null){
                    alFilled.DefaultAccountId__c = con.AccountId;
                    update alFilled;     
                }
            } else if (con.Email == null){
                if (con.AccountId == null){
                    con.AccountId = alMissed.DefaultAccountId__c;
                } else if (con.AccountId != null){
                    alMissed.DefaultAccountId__c = con.AccountId;
                    update alMissed;
                }
            }
        } else if (newContacts.size()!=0 && alFilled !=null && alMissed != null){
            for (Contact contRun : newContacts){
                if (contRun.Email != null && contRun.AccountId == null){
                    contRun.AccountId = alFilled.DefaultAccountId__c; 
                }
                if (contRun.Email == null && contRun.AccountId == null){
                    contRun.AccountId = alMissed.DefaultAccountId__c; 
                }
            }
            
        }
        
        
        
        
    }
    
    
}