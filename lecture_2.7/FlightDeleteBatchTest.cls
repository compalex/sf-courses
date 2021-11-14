@IsTest
private class FlightDeleteBatchTest {
    private static final String JOB_NAME ='Flight Cleaner Process at On the Hour';
    private static final String CRON = '0 30 * * * ?';
    private static final Integer NUM_TO_CREATE = 20;
    private static final Integer DECLINED_NUM_TO_CREATE = 20;

    @IsTest
    static void testFlightDeleteBatch() {
        List<Flight__c> flights = TestDataFactory.createFlights(NUM_TO_CREATE);
        List<Flight__c> declinedFlights = TestDataFactory.createOldDeclinedFlights(DECLINED_NUM_TO_CREATE);
        List<Flight__c> flightsBeforeBatch = [
            SELECT Id
            FROM Flight__c
            WHERE Status__c LIKE :Constants.FLIGHT_STATUS_DECLINED
        ];

        Test.startTest();
            Id batchId = Database.executeBatch(new FlightDeleteBatch());
        Test.stopTest();
    
        List<Flight__c> flightsAfterBatch = [
            SELECT Id
            FROM Flight__c
            WHERE Status__c LIKE :Constants.FLIGHT_STATUS_DECLINED
        ];

        System.assertEquals(DECLINED_NUM_TO_CREATE, flightsBeforeBatch.size());
        System.assertEquals(true, flightsAfterBatch.isEmpty());
    }

    @IsTest
    static void testFlightDeleteSchedulable() {
        Test.startTest();
            String jobId = System.schedule(JOB_NAME, CRON, new FlightDeleteBatch());
        Test.stopTest();

        CronTrigger cronTrigger = [
            SELECT  Id,
                    CronExpression,
                    TimesTriggered
            FROM CronTrigger
            WHERE Id = :jobId
        ];
        
        System.assertEquals(CRON, cronTrigger.CronExpression);
        System.assertEquals(0, cronTrigger.TimesTriggered);
    }
}