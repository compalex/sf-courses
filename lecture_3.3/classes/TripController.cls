public inherited sharing class TripController {
    private static final String DOC_URL = '/sfc/servlet.shepherd/document/download/';
    private static final String FLIGHT_STATUS_OFFER_PENDING = 'Offer Pending';

    @AuraEnabled(cacheable=true)
    public static List<Trip__c> getSuitableTrips(Id touristId) {
        if(touristId == null) {
            return new List<Trip__c>();
        }

        return TripManager.getByExcludeTouristsAndAge(
            new Set<Id>{touristId}, 
            TouristManager.getByIds(new Set<Id>{touristId})[0].Age__c
        );
    }

    @AuraEnabled(cacheable=true)
    public static List<Tourist__c> getSuitableTourists(Id tripId) {
        if(tripId == null) {
            return new List<Tourist__c>();
        }

        return TouristManager.getByActiveAndExcludeTripAndAge(
            tripId, 
            TripManager.getByIds(new Set<Id>{tripId})[0].Minimum_Age__c
        );
    }

    @AuraEnabled(cacheable=true)
    public static String getImageLink(Id tripId) {
        String imgLink;

        if(tripId != null) {
            List<ContentDocumentLink> contentDocLinks = ContentDocumentLinkManager.getByTripId(tripId);

            if(!contentDocLinks.isEmpty()) {
                imgLink = DOC_URL + contentDocLinks[0].ContentDocumentId;
            }
        } 

        return imgLink;
    }

    @AuraEnabled(cacheable=true)
    public static List<Weather_Daily_Forecast__c> getWeatherDailyForecasts(Id tripId) {
        if(tripId == null) {
            return new List<Weather_Daily_Forecast__c>();
        }

        List<Trip__c> trips = TripManager.getByIds(new Set<Id>{tripId});
        List<Weather_Daily_Forecast__c> forecasts = new List<Weather_Daily_Forecast__c>();

        if(!trips.isEmpty()) {
            Id spacePointId = trips[0].Space_Point__c;
            forecasts = WeatherDailyForecastManager.getBySpacePointId(spacePointId);
        }

        return forecasts;
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
                Status__c = FLIGHT_STATUS_OFFER_PENDING
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
