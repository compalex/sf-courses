public with sharing class TripController {
    private static final String DOC_URL = '/sfc/servlet.shepherd/document/download/';

    @AuraEnabled(cacheable=true)
    public static List<Trip__c> getSuitableTrips(Id touristId) {
        return TripManager.getByExcludeTouristsAndAge(
            new Set<Id>{touristId}, 
            TouristManager.getByIds(new Set<Id>{touristId})[0].Age__c
        );
    }

    @AuraEnabled(cacheable=true)
    public static List<Tourist__c> getSuitableTourists(Id tripId) {
        return TouristManager.getByActiveAndExcludeTripAndAge(tripId, 10);
    }

    @AuraEnabled(cacheable=true)
    public static String getImageLink(Id tripId) {
        ContentDocumentLink record = [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :tripId
            LIMIT 1
        ];

        return DOC_URL + record.ContentDocumentId;
    }

    @AuraEnabled(cacheable=true)
    public static Weather_Daily_Forecast__c getWeatherDailyForecasts(Id tripId) {
        Id spacePointId = TripManager.getByIds(new Set<Id>{tripId})[0].Space_Point__c;

        return [
            SELECT Average_Temperature__c, Date__c
            FROM Weather_Daily_Forecast__c
            WHERE Space_Point__c = :spacePointId
        ];
    }
}
