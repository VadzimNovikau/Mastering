@isTest
public class CheckingEmaiContactTest {
   
    public static void setup(){
       List<Account> listAccounts = new List<Account>();
       List<AccountLinking__c> custonSettingsList = new List<AccountLinking__c>();
       Account filledAccEmail = new Account (Name ='FilledAccEmail');
       listAccounts.add(filledAccEmail);
       Account missedAccEmail = new Account (Name ='MissedAccEmail');
       listAccounts.add(missedAccEmail);
       insert listAccounts;
       
       AccountLinking__c filledAccount = new AccountLinking__c (Name = 'FilledContactEmail', DefaultAccountId__c = filledAccEmail.Id);
       custonSettingsList.add(filledAccount);
       AccountLinking__c missedAccount = new AccountLinking__c (Name = 'MissedContactEmail', DefaultAccountId__c = missedAccEmail.Id);
       custonSettingsList.add(missedAccount);
       insert custonSettingsList;   
    }
    
    @isTest  
    static void putContact() {
       setup();
       Account accountTest = new Account(Name = 'TestAcc');
       insert accountTest;
  
       Contact contactTest1 = new Contact(Lastname = 'contactTest1',Email = 'unemail12345@mail.ru', AccountId = accountTest.Id);
       insert contactTest1;
       System.assertEquals(accountTest.Id, AccountLinking__c.getValues('FilledContactEmail').DefaultAccountId__c);
        
       Contact contactTest2 = new Contact(Lastname = 'contactTest2', AccountId = accountTest.Id);
       insert contactTest2;
       System.assertEquals(accountTest.Id, AccountLinking__c.getValues('MissedContactEmail').DefaultAccountId__c);
       
       Contact contactTest3 = new Contact(Lastname = 'contactTest3');
       insert contactTest3;
       System.assertEquals([Select AccountId From Contact Where id =: contactTest3.Id].AccountId, AccountLinking__c.getValues('MissedContactEmail').DefaultAccountId__c);
        
       Contact contactTest4 = new Contact(Lastname = 'contactTest4',Email = 'unemail123455@mail.ru');
       insert contactTest4;
       System.assertEquals([Select AccountId From Contact Where id =: contactTest4.Id].AccountId, AccountLinking__c.getValues('FilledContactEmail').DefaultAccountId__c);
    }
    
    @isTest  
    static void putListContacts() {
       setup();
       Account accountTest = new Account(Name = 'TestAcc');
       insert accountTest;
       
       List<Contact> listContacts = new List<Contact>();
       Contact contactTest1 = new Contact(Lastname = 'contactTest1',Email = 'unemail12345@mail.ru', AccountId = accountTest.Id);
       listContacts.add(contactTest1);
       Contact contactTest2 = new Contact(Lastname = 'contactTest2', AccountId = accountTest.Id);
       listContacts.add(contactTest2);
       Contact contactTest3 = new Contact(Lastname = 'contactTest3');
       listContacts.add(contactTest3);
       Contact contactTest4 = new Contact(Lastname = 'contactTest4',Email = 'unemail12345555@mail.ru');
       listContacts.add(contactTest4);
       insert listContacts;
       System.assertNotEquals([Select AccountId From Contact Where id =: contactTest1.Id].AccountId, AccountLinking__c.getValues('FilledContactEmail').DefaultAccountId__c);
       System.assertNotEquals([Select AccountId From Contact Where id =: contactTest2.Id].AccountId, AccountLinking__c.getValues('MissedContactEmail').DefaultAccountId__c);
       System.assertEquals([Select AccountId From Contact Where id =: contactTest3.Id].AccountId, AccountLinking__c.getValues('MissedContactEmail').DefaultAccountId__c);
       System.assertEquals([Select AccountId From Contact Where id =: contactTest4.Id].AccountId, AccountLinking__c.getValues('FilledContactEmail').DefaultAccountId__c);
    }

}