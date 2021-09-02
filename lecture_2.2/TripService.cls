public class TripService {
    
	@InvocableMethod(label='Fill With Tourists' 
                     description='Fills the Trip with fitting having-no-trips Tourists.' 
                     category='Trip__c')
    public static void fillWithTourists(List<Id> tripId) {
        Trip__c tripToFill = [
            SELECT id, Minimum_Age__c
            FROM Trip__c
            WHERE id = :tripId
        ];
        List<Tourist__c> unregisteredTourists = TouristManager.getUnregistered();
        List<Tourist__c> touristsToFill = new List<Tourist__c>();
        
        for(Tourist__c touristToFill : unregisteredTourists) {
            if(touristToFill.Age__c >= tripToFill.Minimum_Age__c) {
				touristsToFill.add(touristToFill);
            }
        }
        insert getFlights(tripToFill, touristsToFill);
    }
    
    private static List<Flight__c> getFlights(Trip__c tripToFill, List<Tourist__c> touristsToFill) {
        List<Flight__c> flightsToCreate = new List<Flight__c>();
        
        for(Tourist__c touristToFill : touristsToFill) {
            Flight__c newFlight = new Flight__c(
                Tourist__c = touristToFill.Id,
                Trip__c = tripToFill.Id
            );
            flightsToCreate.add(newFlight);            
        }
        return flightsToCreate;
    }
}