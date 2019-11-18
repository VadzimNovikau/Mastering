public with sharing class AccessContactTrHelper {
    public static Set<ID> getParentRoleId(Set<ID> roleIds){
        system.debug('roleIds>>>> '+roleIds);
        Set<ID> currentRoleIds = new Set<ID>();
        for(UserRole userRole :[SELECT Id, ParentRoleId 
                                FROM UserRole 
                                WHERE Id IN: roleIds]){
            currentRoleIds.add(userRole.ParentRoleId);                            
        }
        if(currentRoleIds.size()>0){
            currentRoleIds.addAll(getParentRoleId(currentRoleIds));
        }
        system.debug('currentRoleIds'+currentRoleIds);
        return currentRoleIds;
    }
    
    public static List<User> getUsersOver(Id userRoleId){
        user gurs = [Select UserRoleId,Email,ForecastEnabled 
                     from user where id = :userRoleId LIMIT 1];
        Set<Id> userIdSet = new Set<Id>();
        userIdSet.add(gurs.UserRoleId);
        Set<ID> finalUserIdSet = getParentRoleId(userIdSet);
        finalUserIdSet.remove(null);
        return[SELECT Id
               FROM User
               WHERE UserRoleId IN :finalUserIdSet];
       
    }
    
    public static void addAccessForSharingContacts (List<Contact> newContacts){
        List<ContactShare> contactsForSharing = new List<ContactShare>();
        List<User> usersAboveHierarhy = getUsersOver(Id.valueOf(UserInfo.getUserId()));
        system.debug('usersAboveHierarhy>>>>> ' + usersAboveHierarhy);
        for(Contact contact : newContacts){
            for(User user : usersAboveHierarhy) {
                system.debug('user >>> ' + user);
                ContactShare cs = new ContactShare();
                cs.ContactId = contact.Id;
                cs.UserOrGroupId = user.Id;
                cs.ContactAccessLevel = 'Edit';
                cs.RowCause = Schema.ContactShare.RowCause.Manual;
                system.debug('cs.ContactAccessLevel>>>> ' + cs.ContactAccessLevel);
                contactsForSharing.add(cs);
            }
        }
        Database.SaveResult[] contactsShareInsertResult = Database.insert(contactsForSharing, false);
        //insert contactsForSharing;
        system.debug('contactsShareInsertResult>>>> ' + contactsShareInsertResult);
        system.debug('contactsForSharing>>>> ' + contactsForSharing);
    }
}