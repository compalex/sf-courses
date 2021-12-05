public with sharing class WeatherDailyForecastManager {

    public static List<Weather_Daily_Forecast__c> getBySpacePointId(Id spacePointId) {
        if(spacePointId == null) {
            return new List<Weather_Daily_Forecast__c>();
        }

        return [
            SELECT Average_Temperature__c, Date__c
            FROM Weather_Daily_Forecast__c
            WHERE Space_Point__c = :spacePointId
            AND Date__c = TODAY
        ];
    }
}
