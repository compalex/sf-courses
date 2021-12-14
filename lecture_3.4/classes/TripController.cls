public inherited sharing class TripController {
    private static final String BASE_URL = URL.getSalesforceBaseUrl().toExternalForm();
    private static final String DOC_URL = '/sfc/servlet.shepherd/document/download/';

    @AuraEnabled(cacheable=true)
    public static List<Trip__c> getSuitableTrips(Id touristId) {
        if(touristId == null) {
            return new List<Trip__c>();
        }

        List<Tourist__c> tourists = TouristManager.getByIds(new Set<Id>{touristId});
        List<Trip__c> trips;

        if(tourists.isEmpty()) {
            trips = new List<Trip__c>();
        } else {
            trips = TripManager.getByExcludeTouristsAndAge(new Set<Id>{touristId}, tourists[0].Age__c);
        }

        return trips;
    }

    @AuraEnabled(cacheable=true)
    public static List<Tourist__c> getSuitableTouristsCacheable(Id tripId, Integer limitSize, Integer offset) {
        if(tripId == null || limitSize == null || offset == null) {
            return new List<Tourist__c>();
        }

        List<Trip__c> trips = TripManager.getByIds(new Set<Id>{tripId});
        List<Tourist__c> tourists;

        if(trips.isEmpty()) {
            tourists = new List<Tourist__c>();
        } else {
            tourists = TouristManager.getByActiveAndExcludeTripAndAge(tripId, trips[0].Minimum_Age__c, limitSize, offset);
        }

        return tourists;
    }

    @AuraEnabled(cacheable=true)
    public static String getImageLink(Id tripId) {
        if(tripId == null) {
            throw new AuraHandledException(Label.ServerError);
        }

        List<ContentDocumentLink> contentDocLinks = ContentDocumentLinkManager.getByTripId(tripId);
        String imgLink;

        if(contentDocLinks.isEmpty()) {
            throw new AuraHandledException(Label.ServerError);
        } else {
            imgLink = (BASE_URL + DOC_URL + contentDocLinks[0].ContentDocumentId);
        }

        return imgLink;
    }

    @AuraEnabled(cacheable=true)
    public static Weather_Daily_Forecast__c getWeatherDailyForecast(Id tripId) {
        if(tripId == null) {
            throw new AuraHandledException(Label.ServerError);
        }

        List<Trip__c> trips = TripManager.getByIds(new Set<Id>{tripId});
        List<Weather_Daily_Forecast__c> forecasts = new List<Weather_Daily_Forecast__c>();

        if(trips.isEmpty()) {
            throw new AuraHandledException(Label.ServerError);
        } else {
            Id spacePointId = trips[0].Space_Point__c;
            forecasts = WeatherDailyForecastManager.getBySpacePointId(spacePointId);
        }

        return forecasts.isEmpty() ? null : forecasts[0]; 
    }

    @AuraEnabled
    public static void insertFlights(List<Id> touristIds, Id tripId) {
        if(tripId == null || touristIds == null || touristIds.isEmpty()) {
            throw new AuraHandledException(Label.ServerError);
        }

        try {
            TripService.insertFlights(touristIds, tripId);
        } catch(Exception ex) {
            TripService.logError(ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }
}
