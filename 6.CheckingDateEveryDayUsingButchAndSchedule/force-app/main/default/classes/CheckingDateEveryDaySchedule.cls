global class CheckingDateEveryDaySchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new CheckingDateEveryDay());                
    }
}