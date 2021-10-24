public with sharing class TripInfoController {//tripInfoController
    private final Trip__c trip;    
    public List<Tourist__c> relatedTourists {
        get {
            return getRelatedTourists(trip.Id);
        }
    }

    public List<Tourist__c> unrelatedTourists {
        get {
            return getUnrelatedTourists(trip.Id);
        }
    }

    public TripInfoController(ApexPages.StandardController standardController) {
        trip = (Trip__c) standardController.getRecord();
    }

    private List<Tourist__c> getRelatedTourists(Id tripId) {
        if(String.isBlank(trip.Id)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Constants.NO_TRIP_ID_ERROR));
            return new List<Tourist__c>();
        }

        List<Flight__c> relatedFlights = FlightManager.getByTripIds(new Set<Id>{tripId});
        Set<Id> relatedTourists = new Set<Id>();

        for(Flight__c flight : relatedFlights) {
            relatedTourists.add(flight.Tourist__c);
        }

        return TouristManager.getByIds(relatedTourists);
    }

    private List<Tourist__c> getUnrelatedTourists(Id tripId) {
        if(String.isBlank(trip.Id)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Constants.NO_TRIP_ID_ERROR));
            return new List<Tourist__c>();
        }

        List<Flight__c> relatedFlights = FlightManager.getByTripIds(new Set<Id>{tripId});

        return TouristManager.getByExcludingFlightIds(new Map<Id, Flight__c>(relatedFlights).keyset());
    }
}

