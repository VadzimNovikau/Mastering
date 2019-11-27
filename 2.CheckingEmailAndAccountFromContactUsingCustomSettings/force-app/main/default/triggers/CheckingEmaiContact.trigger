trigger CheckingEmaiContact on Contact (before insert, before update) {
         if (Trigger.isBefore) {
             CheckingEmaiContactTrHelper.checkingProcess(trigger.new);
         }
}