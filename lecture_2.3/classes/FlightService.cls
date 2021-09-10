public with sharing class FlightService {

    public static void declineFlights(List<Tourist__c> inactiveTourists) {
        if(inactiveTourists == null || inactiveTourists.isEmpty()) {
            return;
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