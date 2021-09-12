public with sharing class TouristTriggerHandler {
	public static Boolean isFirstTime = true;
    
    public static void onAfterInsert(Map<Id, Tourist__c> newMap) {
        if(newMap == null || newMap.isEmpty()) {
            return;
        }
        TouristService.markDuplicatesAsync(newMap.keySet());
    }

    public static void onAfterUpdate(Map<Id, Tourist__c> oldMap, Map<Id, Tourist__c> newMap) {
        if(oldMap == null || oldMap.isEmpty() || newMap == null || newMap.isEmpty()) {
            return;
        }
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