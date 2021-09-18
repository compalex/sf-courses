public with sharing class FlightTriggerHandler {
    public static Boolean isFirstTime = true;

    public static void onBeforeInsert(List<Flight__c> newFlights) {
        validateRecords(newFlights);
    }

    public static void onBeforeUpdate(Map<Id, Flight__c> newFlights) {
        validateRecords(newFlights.values());
    }

    private static void validateRecords(List<Flight__c> newFlights) {
        Set<Id> touristIds = new Set<Id>();
        Set<Id> tripIds = new Set<Id>();

        for(Flight__c flight : newFlights) {
            touristIds.add(flight.Tourist__c);
            tripIds.add(flight.Trip__c);
        }
        List<Tourist__c> tourists = TouristManager.getByIds(touristIds);
        List<Trip__c> trips = TripManager.getByIds(tripIds);
        Map<Id, Tourist__c> touristMap = new Map<Id, Tourist__c>(tourists);
        Map<Id, Trip__c> tripMap = new Map<Id, Trip__c>(trips);

        for(Flight__c flight : newFlights) {
            Tourist__c tourist = touristMap.get(flight.Tourist__c);
            Trip__c trip = tripMap.get(flight.Trip__c);
            if(tourist.Age__c < trip.Minimum_Age__c) {
                flight.addError(Constants.ERROR_INVALID_AGE);
            }
            if(trip.Start_Date__c < Date.today()) {
                flight.addError(Constants.ERROR_INVALID_START_DATE);
            }
        }
    }
}