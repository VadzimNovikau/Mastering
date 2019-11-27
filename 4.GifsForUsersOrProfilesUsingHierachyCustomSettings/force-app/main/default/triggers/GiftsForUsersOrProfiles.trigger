trigger GiftsForUsersOrProfiles on Gift__c (before insert) {
      if (Trigger.isBefore) {
            GiftsForUsersOrProfilesTrHelper.checkingProcess(trigger.new);
         }
}