@isTest
public class TestAccessContact {
   @future
   public static void createUserWithRole(String roleName){
     Id roleId = [SELECT Id FROM UserRole WHERE Name LIKE :roleName].Id;
     Profile p = [SELECT Id FROM Profile WHERE Name='SysAdmClone'];
     User user = new User(Alias = 'uid', 
                          Email= 'CreateTestUser@myorg.com', 
                          EmailEncodingKey='UTF-8', 
                          LastName='Testing', 
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', 
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/New_York', 
                          UserName= 'CreateTestUser@myorg.com',
                          UserRoleId = roleId);      
  insert user;       
  }
    
  @isTest  
  static void withAccess() {
    test.startTest();
    createUserWithRole ('Senior Manager');
    test.stopTest();    
    //Create Contact
    Account a = new Account(Name = 'TestAcc');
    insert a;
    Contact contactForSharing = new Contact(Lastname = 'ContactForSharing', AccountId = a.Id);
    insert contactForSharing;
    User testUser = [SELECT Id FROM User WHERE Alias LIKE 'uid'];
  
    //Chenge userRole with access and check      
    System.runAs(testUser){
    List<Contact> con = [SELECT Id, Lastname FROM Contact];
    system.debug('con ....' + con.size());
    System.assertEquals(con.size(), 1);
    System.assertEquals(con[0].Lastname, 'ContactForSharing');
    }
  }
      
  @isTest  
  static void withoutAccess() {    
    test.startTest();
    createUserWithRole ('Junior Manager');
    test.stopTest();
    //Create Contact
    Account a = new Account(Name = 'TestAcc');
    insert a;
    Contact contactForSharing = new Contact(Lastname = 'ContactForSharing2', AccountId = a.Id);
    insert contactForSharing;
    User testUser = [SELECT Id FROM User WHERE Alias LIKE 'uid'];
  
    //Chenge userRole with access and check      
    System.runAs(testUser){
    List<Contact> con = [SELECT Id, Lastname FROM Contact];
    System.assertEquals(con.size(), 0);
    }
       
  }
    
}