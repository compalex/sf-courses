@IsTest
private class FlightManagerTest {
    private static final Integer NUM_TO_CREATE = 10;

    @IsTest
    static void testGetByTouristIds() {
        Map<Id, Flight__c> flightsFromFactory = new Map<Id, Flight__c>(TestDataFactory.createFlights(NUM_TO_CREATE));
        Set<Id> touristIds = new Set<Id>();

        for(Flight__c flight : flightsFromFactory.values()) {
            touristIds.add(flight.Tourist__c);
        }
        List<Flight__c> flightsFromDB = FlightManager.getByTouristIds(touristIds);

        System.assertNotEquals(null, flightsFromDB);
        System.assertEquals(NUM_TO_CREATE, flightsFromDB.size());
        System.assertEquals(true, flightsFromFactory.keySet().contains(flightsFromDB[0].Id));
    }

    @IsTest
    static void testGetByTourists_forNull() {
        List<Flight__c> flights = FlightManager.getByTouristIds(null);
        System.assertEquals(true, flights.isEmpty());
    }

    @IsTest
    static void testGetByTourists_forEmptiness() {
        List<Flight__c> flights = FlightManager.getByTouristIds(new Set<Id>());
        System.assertEquals(true, flights.isEmpty());
    }
}