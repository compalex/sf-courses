public with sharing class FlightManager {

    public static List<Flight__c> getById(Set<Id> flightIds) {
        if(flightIds == null || flightIds.isEmpty()) {
            return new List<Flight__c>();
        }
        return [
                SELECT id,
                       Tourist__r.Age__c,
                       Trip__r.Minimum_Age__c,
                       Trip__r.Start_Date__c
                FROM Flight__c
                WHERE id IN :flightIds
        ];
    }

    public static List<Flight__c> getByTourists(List<Tourist__c> tourists) {
        if(tourists == null || tourists.isEmpty()) {
            return new List<Flight__c>();
        }
        return [
                SELECT Status__c
                FROM Flight__c
                WHERE Tourist__c IN :tourists
        ];
    }
}