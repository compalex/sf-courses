@IsTest
private class TouristTriggerTest {
    private static final Integer NUM_TO_CREATE = 10;
    private static final Integer DUPLICATE_NUM = 3;
    private static final Integer INACTIVE_NUM = 4;

    @IsTest
    static void testOnAfterInsert() {
        Test.startTest();
            Map<Id, Tourist__c> tourists = new Map<Id, Tourist__c>(TestDataFactory.createTourists(NUM_TO_CREATE));
            Map<Id, Tourist__c> duplicates = new Map<Id, Tourist__c>(
                TestDataFactory.createDuplicateTourists(tourists.values(), DUPLICATE_NUM)
            );
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
    static void testOnAfterUpdate() { //TODO
        TestDataFactory.createFlights(NUM_TO_CREATE);
        List<Tourist__c> tourists = [
            SELECT Active__c
            FROM Tourist__c
            WHERE Active__c = true
        ];
        List<Tourist__c> inactiveTourists = new List<Tourist__c>();

        for(Integer i = 0; i < INACTIVE_NUM; i++) {
            tourists.get(i).Active__c = false;
            inactiveTourists.add(tourists.get(i));
        }

        Test.startTest();
            update inactiveTourists;
        Test.stopTest();

        List<Flight__c> declinedFlights = [
            SELECT Id
            FROM Flight__c
            WHERE Status__c LIKE :Constants.FLIGHT_STATUS_ACCEPTED
        ];

        System.assertNotEquals(null, inactiveTourists);
        System.assertNotEquals(null, declinedFlights);
        System.assertEquals(NUM_TO_CREATE, tourists.size());
        System.assertEquals(INACTIVE_NUM, inactiveTourists.size());
        System.assertEquals(false, inactiveTourists[0].Active__c);
        System.assertEquals(INACTIVE_NUM, declinedFlights.size());
        System.assertEquals(Constants.FLIGHT_STATUS_DECLINED, declinedFlights[0].Status__c);
    }
}
