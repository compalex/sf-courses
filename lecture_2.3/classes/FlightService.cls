public with sharing class FlightService {

    public static void declineFlightsOfInactiveTourists(List<Tourist__c> newTourists) {
        if(newTourists == null || newTourists.isEmpty()) {
            return;
        }
        List<Tourist__c> inactiveTourists = new List<Tourist__c>();

        for(Tourist__c newTourist : newTourists) {
            if(!newTourist.Active__c) {
                inactiveTourists.add(newTourist);
            }
        }
        List<Flight__c> flights = FlightManager.getByTourists(inactiveTourists);

        for(Flight__c flight : flights) {
            flight.Status__c = Constants.FLIGHT_STATUS_DECLINED;
        }
        if(!flights.isEmpty()) {
            update flights;
        }
    }
}