public with sharing class FlightTriggerHandler {
    public static Boolean isFirstTime = true;

    public static void onAfterInsert(Map<Id, Flight__c> newFlights) {
        if(newFlights == null || newFlights.isEmpty()) {
            return;
        }
        validateRecords(newFlights);
    }

    public static void onBeforeUpdate(Map<Id, Flight__c> newFlights) {
        if(newFlights == null || newFlights.isEmpty()) {
            return;
        }
        validateRecords(newFlights);
    }

    private static void validateRecords(Map<Id, Flight__c> newFlights) {
        List<Flight__c> flightsWithParentFields = FlightManager.getByIds(newFlights.keySet());

        for(Flight__c flightWithFields : flightsWithParentFields) {
            if(flightWithFields.Tourist__r.Age__c < flightWithFields.Trip__r.Minimum_Age__c) {
                newFlights.get(flightWithFields.Id).addError(Constants.ERROR_INVALID_AGE);
            }
            if(flightWithFields.Trip__r.Start_Date__c < Date.today()) {
                newFlights.get(flightWithFields.Id).addError(Constants.ERROR_INVALID_START_DATE);
            }
        }
    }
}