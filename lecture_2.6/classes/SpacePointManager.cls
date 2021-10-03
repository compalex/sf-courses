public with sharing class SpacePointManager {

    public static List<Space_Point__c> getAll() {
        return [
            SELECT Latitude__c,
                   Longitude__c,
                   City__c,
                   (SELECT Date__c FROM Weather_Daily_Forecasts__r)
            FROM Space_Point__c
        ];
    }
}