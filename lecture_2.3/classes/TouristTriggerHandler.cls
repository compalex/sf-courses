public with sharing class TouristTriggerHandler {
    public static Boolean isFirstTime = true;
    
    public static void onBeforeInsert(List<Tourist__c> tourists) {
        if(tourists == null || tourists.isEmpty()) {
            return;
        }
        TouristService.markDuplicates(tourists);
        FlightService.declineFlightsOfInactiveTourists(tourists);
    }

    public static void onBeforeUpdate(List<Tourist__c> tourists) {
        if(tourists == null || tourists.isEmpty()) {
            return;
        }
        FlightService.declineFlightsOfInactiveTourists(tourists);
    }
}
