public with sharing class FlightManager {

    public static List<Flight__c> getByTouristIds(Set<Id> touristIds) {
        if(touristIds == null || touristIds.isEmpty()) {
            return new List<Flight__c>();
        }

        return [
                SELECT Status__c
                FROM Flight__c
                WHERE Tourist__c IN :touristIds
        ];
    }

    public static List<Flight__c> getByTripIds(Set<Id> tripIds) {
        if(tripIds == null || tripIds.isEmpty()) {
            return new List<Flight__c>();
        }

        return [
            SELECT Tourist__c
            FROM Flight__c
            WHERE Trip__c IN :tripIds
        ];
    }
}