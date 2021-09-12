public with sharing class FlightService {

    public static void declineFlights(Set<Id> touristIds) {
        if(touristIds == null || touristIds.isEmpty()) {
            return;
        }
        List<Flight__c> flights = FlightManager.getByTouristIds(touristIds);

        for(Flight__c flight : flights) {
            flight.Status__c = Constants.FLIGHT_STATUS_DECLINED;
        }
        update flights;
    }
}