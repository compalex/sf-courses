@IsTest
private class TouristServiceTest {
    private static final Integer NUM_TO_CREATE = 20;
    private static final Integer NUM_TO_MARK = 8;
    private static final Integer NUM_NOT_TO_MARK = 5;

    @IsTest
    static void testMarkDuplicatesAsync() {
        TouristTriggerHandler.bypassTrigger = true;
        Map<Id, Tourist__c> touristsFromFactory = new Map<Id, Tourist__c>(TestDataFactory.createTourists(NUM_TO_CREATE));
        Map<Id, Tourist__c> touristsToCheck = new Map<Id, Tourist__c>(
            TestDataFactory.createDuplicateTourists(touristsFromFactory.values(), NUM_TO_MARK)
        );
        touristsToCheck.putAll(TestDataFactory.createTourists(NUM_NOT_TO_MARK));

        Test.startTest();
            TouristService.markDuplicatesAsync(touristsToCheck.keySet());
        Test.stopTest();

        List<Tourist__c> resultTourists = [
            SELECT IsDuplicate__c
            FROM Tourist__c
            WHERE IsDuplicate__c = true
        ];

        System.assertEquals(NUM_TO_MARK, resultTourists.size());
    }
}