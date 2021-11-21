public inherited sharing class TripController {
    private static final String DOC_URL = '/sfc/servlet.shepherd/document/download/';

    @AuraEnabled(cacheable=true)
    public static List<Trip__c> getSuitableTrips(Id touristId) {
        if(touristId == null) {
            return new List<Trip__c>();
        }

        List<Tourist__c> tourists = TouristManager.getByIds(new Set<Id>{touristId});
        List<Trip__c> trips;

        if(!tourists.isEmpty()) {
            trips = TripManager.getByExcludeTouristsAndAge(
                new Set<Id>{touristId},
                tourists[0].Age__c
            );
        } else {
            trips = new List<Trip__c>();
        }

        return trips;
    }

    @AuraEnabled(cacheable=true)
    public static List<Tourist__c> getSuitableTourists(Id tripId, Integer limitSize, Integer offset) {
        if(tripId == null) {
            return new List<Tourist__c>();
        }

        List<Trip__c> trips = TripManager.getByIds(new Set<Id>{tripId});
        List<Tourist__c> tourists;

        if(!trips.isEmpty()) {
            tourists = TouristManager.getByActiveAndExcludeTripAndAge(
                tripId,
                trips[0].Minimum_Age__c,
                limitSize,
                offset
            );
        } else {
            tourists = new List<Tourist__c>();
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

        if(!contentDocLinks.isEmpty()) {
            imgLink = DOC_URL + contentDocLinks[0].ContentDocumentId;
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

        if(!trips.isEmpty()) {
            Id spacePointId = trips[0].Space_Point__c;
            forecasts = WeatherDailyForecastManager.getBySpacePointId(spacePointId);
        }

        return !forecasts.isEmpty() ? forecasts[0] : null; 
    }

    @AuraEnabled
    public static List<Flight__c> insertFlights(List<Id> touristIds, Id tripId) {
        if(tripId == null || touristIds == null || touristIds.isEmpty()) {
            return new List<Flight__c>();
        }

        List<Flight__c> flights = new List<Flight__c>();

        for(Id touristId : touristIds) {
            FLight__c flight = new Flight__c(
                Tourist__c = touristId,
                Trip__c = tripId,
                Status__c = Constants.FLIGHT_STATUS_OFFER_PENDING
            );
            flights.add(flight);
        }

        try {
            insert flights;
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        
        return flights;
    }
}
