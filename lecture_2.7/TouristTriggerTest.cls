@IsTest
private class TouristTriggerTest {
    private static final Integer NUM_TO_CREATE = 10;
    private static final Integer DUPLICATE_NUM = 3;
    private static final Integer INACTIVE_NUM = 4;

    @IsTest
    static void testOnAfterInsert() {
        Test.startTest();
            List<Tourist__c> tourists = TestDataFactory.createTourists(NUM_TO_CREATE);
            List<Tourist__c> duplicates = TestDataFactory.createDuplicateTourists(tourists, DUPLICATE_NUM);
        Test.stopTest();

        List<Tourist__c> resultTourists = [
            SELECT IsDuplicate__c
            FROM Tourist__c
            WHERE IsDuplicate__c = true
        ];

        System.assertNotEquals(null, resultTourists);
        System.assertEquals(DUPLICATE_NUM, resultTourists.size());
        System.assertEquals(true, resultTourists[0].IsDuplicate__c);
    }

    @IsTest 
    static void testOnAfterUpdate() { 
        List<Flight__c> flights = TestDataFactory.createFlights(NUM_TO_CREATE);
        List<Tourist__c> inactiveTourists = new List<Tourist__c>();

        for(Integer i = 0; i < INACTIVE_NUM; i++) {
            flights.get(i).Tourist__r.Active__c = false;
            inactiveTourists.add(flights.get(i).Tourist__r);
        }
        TouristTriggerHandler.isFirstTime = true;

        Test.startTest();
            update inactiveTourists;
        Test.stopTest();

        List<Flight__c> declinedFlights = [
            SELECT Id, Status__c
            FROM Flight__c
            WHERE Status__c = :Constants.FLIGHT_STATUS_DECLINED
        ];

        System.assertEquals(NUM_TO_CREATE, flights.size());
        System.assertEquals(INACTIVE_NUM, inactiveTourists.size());
        System.assertEquals(false, inactiveTourists[0].Active__c);
        System.assertEquals(INACTIVE_NUM, declinedFlights.size());
        System.assertEquals(Constants.FLIGHT_STATUS_DECLINED, declinedFlights[0].Status__c);
    }
}
