trigger ContactTrig on Contact (after insert, before insert, before update) {
    if (Trigger.isBefore) {
             CheckingEmaiContactTrHelper.checkingProcess(trigger.new);
    }
    if (Trigger.isInsert && Trigger.isAfter) {
       AccessContactTrHelper.addAccessForSharingContacts(trigger.new);
    }
    if (Trigger.isBefore && Trigger.isInsert) {
            FillingMobileOperatorInContactTrHelper.checkingProcess(trigger.new);
    }

}