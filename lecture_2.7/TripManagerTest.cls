@IsTest
private class TripManagerTest {
    private static final Integer NUM_TO_CREATE = 10;

    @IsTest
    static void testGetByIds() {
        Map<Id, Trip__c> tripsFromFactory = new Map<Id, Trip__c>(TestDataFactory.createTrips(NUM_TO_CREATE));
        Map<Id, Trip__c> tripsFromDB = new Map<Id, Trip__c>(TripManager.getByIds(tripsFromFactory.keySet()));

        System.assertNotEquals(null, tripsFromDB);
        System.assertEquals(NUM_TO_CREATE, tripsFromDB.size());
        System.assertEquals(tripsFromFactory.keySet(), tripsFromDB.keySet());
    }

    @IsTest
    static void testGetByIds_forNull() {
        List<Trip__c> trips = TripManager.getByIds(null);
        System.assertEquals(true, trips.isEmpty());
    }

    @IsTest
    static void testGetByIds_forEmptiness() {
        List<Trip__c> trips = TripManager.getByIds(new Set<Id>());
        System.assertEquals(true, trips.isEmpty());
    }
}