global with sharing class WeatherForecastUpdater implements Schedulable {

    global void execute(SchedulableContext ctx) {
        updateForecasts();
    }

    @Future(Callout=true)
    public static void updateForecasts() {
        List<Space_Point__c> spacePoints = SpacePointManager.getAll();
        List<Weather_Daily_Forecast__c> forecastsToDelete = new List<Weather_Daily_Forecast__c>();
        List<Weather_Daily_Forecast__c> forecastsToInsert = new List<Weather_Daily_Forecast__c>();

        for(Space_Point__c spacePoint : spacePoints) {
            String jsonBody;

            try {
                jsonBody = WeatherForecastService.getForecasts(spacePoint.Latitude__c, spacePoint.Longitude__c);
            } catch (WeatherForecastException ex) {
                System.debug(LoggingLevel.ERROR, ex.getMessage());
            }
            Map<Date, Decimal> tempsByDate = WeatherForecastService.parseJSONBodyUntyped(jsonBody);
            forecastsToDelete.addAll(spacePoint.Weather_Daily_Forecasts__r);
            forecastsToInsert.addAll(getForecastsToInsert(tempsByDate, spacePoint));
        }

        delete forecastsToDelete;
        insert forecastsToInsert;
    }

    private static List<Weather_Daily_Forecast__c> getForecastsToInsert(
            Map<Date, Decimal> tempsByDate,
            Space_Point__c spacePoint
    ) {
        List<Weather_Daily_Forecast__c> forecastsToInsert = new List<Weather_Daily_Forecast__c>();

        for(Date forecastDate : tempsByDate.keySet()) {
            forecastsToInsert.add(new Weather_Daily_Forecast__c(
                    Name = spacePoint.City__c + forecastDate,
                    Space_Point__c = spacePoint.Id,
                    Date__c = forecastDate,
                    Average_Temperature__c = tempsByDate.get(forecastDate)
            ));
        }

        return forecastsToInsert;
    }
}