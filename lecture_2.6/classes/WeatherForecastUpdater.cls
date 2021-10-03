global with sharing class WeatherForecastUpdater implements Schedulable {

    global void execute(SchedulableContext ctx) {
        updateForecasts();
    }

    @future
    public static void updateForecasts() {
        List<Space_Point__c> spacePoints = SpacePointManager.getAll();
        List<Weather_Daily_Forecast__c> forecastsToDelete = new List<Weather_Daily_Forecast__c>();
        List<Weather_Daily_Forecast__c> forecastsToUpdate = new List<Weather_Daily_Forecast__c>();
        List<Weather_Daily_Forecast__c> forecastsToInsert = new List<Weather_Daily_Forecast__c>();

        for(Space_Point__c spacePoint : spacePoints) {
            String jsonBody;

            try {
                jsonBody = WeatherForecastService.getForecasts(spacePoint.Latitude__c, spacePoint.Longitude__c);
            } catch (WeatherForecastException ex) {
                System.debug(LoggingLevel.ERROR, ex.getMessage());
            }
            Map<Date, Decimal> tempsByDate = WeatherForecastService.parseJSONBodyUntyped(jsonBody);
            Map<Date, Weather_Daily_Forecast__c> existingForecastsByDate = getExistingForecastsByDate(spacePoint);

            forecastsToDelete = getForecastsToDelete(forecastsToDelete, existingForecastsByDate);
            forecastsToUpdate = getForecastsToUpdate(forecastsToUpdate, existingForecastsByDate, tempsByDate);
            forecastsToInsert = getForecastsToInsert(forecastsToInsert, existingForecastsByDate, tempsByDate, spacePoint);
        }

        delete forecastsToDelete;
        update forecastsToUpdate;
        insert forecastsToInsert;
    }

    private static Map<Date, Weather_Daily_Forecast__c> getExistingForecastsByDate(Space_Point__c spacePoint) {
        Map<Date, Weather_Daily_Forecast__c> existingForecastsByDate = new Map<Date, Weather_Daily_Forecast__c>();

        for(Weather_Daily_Forecast__c existingForecast : spacePoint.Weather_Daily_Forecasts__r) {
            existingForecastsByDate.put(existingForecast.Date__c, existingForecast);
        }

        return existingForecastsByDate;
    }

    private static List<Weather_Daily_Forecast__c> getForecastsToDelete(
            List<Weather_Daily_Forecast__c> forecastsToDelete,
            Map<Date, Weather_Daily_Forecast__c> existingForecastsByDate) {

        for(Weather_Daily_Forecast__c existingForecast : existingForecastsByDate.values()) {
            if(existingForecast.Date__c < Date.today()) {
                forecastsToDelete.add(existingForecast);
            }
        }

        return forecastsToDelete;
    }

    private static List<Weather_Daily_Forecast__c> getForecastsToUpdate(
            List<Weather_Daily_Forecast__c> forecastsToUpdate,
            Map<Date, Weather_Daily_Forecast__c> existingForecastsByDate,
            Map<Date, Decimal> tempsByDate) {

        for(Date forecastDate : tempsByDate.keySet()) {
            if (existingForecastsByDate.containsKey(forecastDate)) {
                Weather_Daily_Forecast__c forecast = existingForecastsByDate.get(forecastDate);
                forecast.Average_Temperature__c = tempsByDate.get(forecastDate);
                forecastsToUpdate.add(forecast);
            }
        }

        return forecastsToUpdate;
    }

    private static List<Weather_Daily_Forecast__c> getForecastsToInsert(
            List<Weather_Daily_Forecast__c> forecastsToInsert,
            Map<Date, Weather_Daily_Forecast__c> existingForecastsByDate,
            Map<Date, Decimal> tempsByDate,
            Space_Point__c spacePoint) {

        for(Date forecastDate : tempsByDate.keySet()) {
            if (!existingForecastsByDate.containsKey(forecastDate)) {
                forecastsToInsert.add(new Weather_Daily_Forecast__c(
                        Name = spacePoint.City__c + forecastDate,
                        Space_Point__c = spacePoint.Id,
                        Date__c = forecastDate,
                        Average_Temperature__c = tempsByDate.get(forecastDate)
                ));
            }
        }

        return forecastsToInsert;
    }
}