public with sharing class TripService {
    
    public static Set<Id> insertFlights(List<Id> touristIds, Id tripId) {
        if(touristIds == null || touristIds.isEmpty() || String.isBlank(tripId)) {
            throw new AuraHandledException(Label.ServerError);
        }

        List<Flight__c> flights = new List<Flight__c>();

        for(Id touristId : touristIds) {
            flights.add(
                new Flight__c(
                    Tourist__c = touristId,
                    Trip__c = tripId,
                    Status__c = Constants.FLIGHT_STATUS_OFFER_PENDING
                )
            );
        }
        insert flights;

        return new Map<Id, Flight__c>(flights).keySet();
    }

    public static List<TripWrapper> getNearestTrips(List<Trip__c> trips, Decimal latitude, Decimal longitude) {
        if(latitude == null || longitude == null) {
            return new List<TripWrapper>();
        }

        List<TripWrapper> tripWrappers = new List<TripWrapper>();

        for(Trip__c trip : trips) {
            tripWrappers.add(new TripWrapper(
                trip,
                NumberUtility.getDistanceBetweenGeolocations(latitude, longitude, trip.Latitude__c, trip.Longitude__c)
            ));
        }
        tripWrappers.sort();

        List<TripWrapper> tripsToReturn = new List<TripWrapper>();
        Decimal max = Community_App__mdt.getInstance(Constants.CUSTOM_MDT_TYPES_MAIN_APP).Nearest_Spacepoints_Num__c;

        for(Integer i = 0; i < max; i++) {
            tripsToReturn.add(tripWrappers[i]);
        }

        return tripsToReturn;
    }

    public static List<ProductWrapper> getProductWrappers(List<Trip__c> trips) {
        if(trips == null || trips.isEmpty()) {
            return new List<ProductWrapper>();
        }

        Map<Id, Trip__c> tripByIds = new Map<Id, Trip__c>(trips);
        List<PricebookEntry> pricebookEntries = PricebookEntryManager.getByTripIds(tripByIds.keySet());
        List<ProductWrapper> productWrappers = new List<ProductWrapper>();

        for(PricebookEntry pricebookEntry : pricebookEntries) {
            productWrappers.add(
                new ProductWrapper(
                    tripByIds.get(pricebookEntry.TripId__c), 
                    pricebookEntry
                )
            );
        }
        return productWrappers;
    }
}