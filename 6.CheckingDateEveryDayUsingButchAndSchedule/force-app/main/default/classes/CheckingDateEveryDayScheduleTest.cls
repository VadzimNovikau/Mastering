@isTest
public class CheckingDateEveryDayScheduleTest {
    @isTest
    static void checkProcessor() {
      
        List<AsyncApexJob> jobsScheduled = [
            SELECT Id
            FROM AsyncApexJob
            WHERE JobType = 'ScheduledApex'
        ];

        System.assertEquals(0, jobsScheduled.size());
        Test.startTest();
        System.schedule('ScheduledApexForTest', '0 0 0 1/1 * ? *', new CheckingDateEveryDaySchedule());
        Test.stopTest();
        
        jobsScheduled = [
            SELECT Id, ApexClass.Name
            FROM AsyncApexJob
            WHERE JobType = 'ScheduledApex'
        ];

        System.assertEquals(1, jobsScheduled.size());
        System.assertEquals('CheckingDateEveryDaySchedule', jobsScheduled[0].ApexClass.Name);
    }
}