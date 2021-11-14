@IsTest
private class FlightTriggerTest {
    private static final Integer NUM_TO_CREATE = 10;
    private static final String UPDATED_STATUS = 'Offer Pending';
    
    @IsTest
    static void testOnBeforeInsert() {
        List<Flight__c> unvalidFlights = new List<Flight__c>();

        for(Integer i = 0; i < NUM_TO_CREATE; i++) {
            unvalidFlights.add(
                TestDataFactory.createUnvalidFlight()
            );
        }
        DmlException exToCatch;

        Test.startTest();
            try {
                insert unvalidFlights;
            } catch(DmlException ex) {
                exToCatch = ex;
            }
        Test.stopTest();
        
        List<Flight__c> insertedFlights = [
            SELECT Id
            FROM Flight__c
        ];

        System.assertEquals(true, insertedFlights.isEmpty());
        System.assertEquals(true, exToCatch.getMessage().contains(Constants.ERROR_INVALID_AGE));
    }

    @IsTest
    static void testOnBeforeUpdate() {
        Flight__c flight = TestDataFactory.createValidFlight();
        insert flight;

        Trip__c relatedTrip = TripManager.getByIds(new Set<Id>{flight.Trip__c})[0];
        relatedTrip.Start_Date__c = Date.today() - 1;
        update relatedTrip;
        
        DmlException exToCatch;
        flight.Status__c = UPDATED_STATUS;

        Test.startTest();
            try {
                update flight;
            } catch(DmlException ex) {
                exToCatch = ex;
            }
        Test.stopTest();

        Trip__c tripOfUpdatedFlight = [
            SELECT Start_Date__c
            FROM Trip__c
            WHERE Id = :flight.Trip__c
        ];

        System.assertEquals(Date.today() - 1, tripOfUpdatedFlight.Start_Date__c);
        System.assertEquals(true, exToCatch.getMessage().contains(Constants.ERROR_INVALID_START_DATE));
    }
}
