public with sharing class TouristTriggerHandler {
	public static Boolean isFirstTime = true;
    
    @TestVisible
    private static Boolean bypassTrigger = false;

    public static void onAfterInsert(Map<Id, Tourist__c> newMap) {
        if(bypassTrigger) return;

        TouristService.markDuplicatesAsync(newMap.keySet());
    }

    public static void onAfterUpdate(Map<Id, Tourist__c> oldMap, Map<Id, Tourist__c> newMap) {
        Set<Id> inactiveTouristIds = new Set<Id>();

        for(Id touristId : newMap.keySet()) {
            Tourist__c oldTourist = oldMap.get(touristId);
            Tourist__c newTourist = newMap.get(touristId);

            if(oldTourist.Active__c && !newTourist.Active__c) {
                inactiveTouristIds.add(touristId);
            }
        }
        FlightService.declineFlights(inactiveTouristIds);
    }
}   