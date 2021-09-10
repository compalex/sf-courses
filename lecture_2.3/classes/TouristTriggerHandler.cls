public with sharing class TouristTriggerHandler {
	public static Boolean isFirstTime = true;
    
    public static void onBeforeInsert(List<Tourist__c> tourists) {
        if(tourists == null || tourists.isEmpty()) {
            return;
        }
        TouristService.markDuplicates(tourists);
    }

    public static void onAfterUpdate(List<Tourist__c> tourists) {
        if(tourists == null || tourists.isEmpty()) {
            return;
        }
        List<Tourist__c> inactiveTourists = new List<Tourist__c>();

        for(Tourist__c tourist : tourists) {
            if(!tourist.Active__c) {
                inactiveTourists.add(tourist);
            }
        }
        FlightService.declineFlights(inactiveTourists);
    }
}