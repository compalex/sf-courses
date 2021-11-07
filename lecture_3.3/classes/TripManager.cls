public class TripManager {
    
    public static List<Trip__c> getByIds(Set<Id> ids) {
        if(ids == null || ids.isEmpty()) {
            return new List<Trip__c>();
        }
        
        return [
            SELECT Name, Minimum_Age__c, Start_Date__c, Space_Point__c, CreatedDate
            FROM Trip__c
            WHERE Id IN :ids
        ];
    }  

    public static List<Trip__c> getByExcludeTouristsAndAge(Set<Id> excludeTouristIds, Decimal age) {
        if(excludeTouristIds == null || excludeTouristIds.isEmpty()) {
            return new List<Trip__c>();
        }

        return [
            SELECT Name
            FROM Trip__c
            WHERE Id NOT IN (
                SELECT Trip__c
                FROM Flight__c
                WHERE Tourist__c IN :excludeTouristIds
            ) AND Minimum_Age__c <= :age
            AND Start_Date__c > TODAY 
        ];
    }
}