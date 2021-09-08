public class TouristManager {
	
    public static List<Tourist__c> getByName(String name) {
        if(String.isBlank(name)) {
            return new List<Tourist__c>();
        }
        return [
            SELECT Name, Age__c 
            FROM Tourist__c 
            WHERE Name LIKE :name
        ];
    }
    
    public static List<Tourist__c> getByAge(Set<Integer> ages) {
        if(ages == null || ages.isEmpty()) {
            return new List<Tourist__c>();
        }
        return [
            SELECT Name, Age__c 
            FROM Tourist__c 
            WHERE Age__c IN :ages
        ];
    }
    
    public static List<Tourist__c> getByStartDate(Date startDate) {
        if(startDate == null) {
            return new List<Tourist__c>();
        }
        return [
		SELECT Name, Age__c 
            	FROM Tourist__c 
		WHERE Id IN (
                SELECT Tourist__c 
                FROM Flight__c 
                WHERE Trip__r.Start_date__c >= :startDate
            )
        ];
    }
    
    public static List<Tourist__c> getByLastName(Set<String> lastNames) {
        if(lastNames == null || lastNames.isEmpty()) {
            return new List<Tourist__c>();
        }
        return [
            SELECT LastName__c, Email__c
            FROM Tourist__c
            WHERE LastName__c IN :lastNames
        ];
    }
    
    public static List<Tourist__c> getWithRelatedTrips() {
        return [
            SELECT Name, 
            	   Age__c, 
                   (SELECT Trip__r.Start_Date__c, Trip__r.Name FROM Flights__r) 
            FROM Tourist__c
        ];
    }
    
    public static List<Tourist__c> getUnregistered() {
        return [
            SELECT Name, Age__c 
            FROM Tourist__c 
            WHERE Number_Of_Trips__c = 0
        ];
    }
}
