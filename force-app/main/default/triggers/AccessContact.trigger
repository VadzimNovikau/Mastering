trigger AccessContact on Contact (after insert) {
    if (Trigger.isInsert) {
        AccessContactTrHelper.addAccessForSharingContacts(trigger.new);
      /*List<ContactShare> contactsForSharing = new List<ContactShare>();
      for(Contact contact : trigger.new){
       for (User u : [   SELECT Id FROM User where User.Name = 'UserAbove']) 
           {
               ContactShare a = new ContactShare()
               a.ContactId = contact.id;  // record to which  we need to give access to.
               a.UserOrGroupId = u.Id; //Set the portal user Id to share the accounts with
               a.ContactAccessLevel = 'Edit';
               a.RowCause = 'Manual';
               contactsForSharing.add(a);
 
}
Insert contactsForSharing;
      }*/
  }
}