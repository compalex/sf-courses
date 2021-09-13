public class TripManager {
    
    public static List<Trip__c> getByIds(Set<Id> ids) {
        if(ids == null || ids.isEmpty()) {
            return null;
        }
        
        return [
            SELECT Minimum_Age__c, Start_Date__c
            FROM Trip__c
            WHERE Id IN :ids
        ];
    }  
}