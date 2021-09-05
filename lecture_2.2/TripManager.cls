public class TripManager {
    
    public static Trip__c getById(List<Id> tripId) {
        if(tripId == null || tripId.isEmpty()) {
            return null;
        }
        
        return [
            SELECT id, Minimum_Age__c
            FROM Trip__c
            WHERE id = :tripId
        ];
    }  
}