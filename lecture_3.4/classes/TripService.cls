public class TripService {
    
    public static void insertFlights(List<Id> touristIds, Id tripId) {
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
    }

    public static void logError(Exception ex) {
        System.debug(LoggingLevel.ERROR, ex.getLineNumber() + ': ' + ex.getMessage() + '\n' + ex.getStackTraceString());
    }
}