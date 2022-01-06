public class TouristManager {

    public static List<Tourist__c> getByIds(Set<Id> ids) {
        if(ids == null || ids.isEmpty()) {
            return new List<Tourist__c>();
        }

        return [
            SELECT Name, Age__c, Duplicate_Key__c, Active__c
            FROM Tourist__c
            WHERE Id IN :ids
        ];
    }
    
    public static List<Tourist__c> getByDuplicateKeys(Set<String> duplicateKeys, Set<Id> excludeIds) {
        if(duplicateKeys == null || duplicateKeys.isEmpty()) {
            return new List<Tourist__c>();
        }

        return [
            SELECT Duplicate_Key__c
            FROM Tourist__c
            WHERE Duplicate_Key__c IN :duplicateKeys
                AND Id NOT IN :excludeIds
        ];
    }

    public static List<Tourist__c> getByExcludingFlightIds(Set<Id> excludeFlightIds) {
        if(excludeFlightIds == null || excludeFlightIds.isEmpty()) {
            return new List<Tourist__c>();
        }

        return [
            SELECT Name
            FROM Tourist__c
            WHERE Id NOT IN (
                SELECT Tourist__c
                FROM Flight__c
                WHERE Id NOT IN :excludeFlightIds
            )
            ORDER BY Upcoming_Flights_Count__c
            LIMIT 10      
        ];
    }

    public static List<Tourist__c> getByFuzzyname(String fuzzyname) {
        if(String.isBlank(fuzzyname)) {
            return new List<Tourist__c>();
        }

        List<List<Object>> tourists = [
            FIND :fuzzyname
            IN NAME FIELDS
            RETURNING Tourist__c(Name)
        ];

        return tourists.isEmpty() ? null : (List<Tourist__c>) tourists[0];
    }

    public static List<Tourist__c> getByFuzzynameAndAge(String fuzzyname, Integer age) {
        if(String.isBlank(fuzzyname) || age == null) {
            return new List<Tourist__c>();
        }

        List<List<Object>> tourists = [
            FIND :fuzzyname
            IN NAME FIELDS
            RETURNING Tourist__c(Name, Age__c WHERE Age__c = :age)
        ];

        return tourists.isEmpty() ? null : (List<Tourist__c>) tourists[0];
    }

    public static List<Tourist__c> getByActiveAndExcludeTripAndAge(
        Id excludeTripId, 
        Decimal minAge, 
        Integer limitSize, 
        Integer offset
    ) {
        if(String.isBlank(excludeTripId) || minAge == null) {
            return new List<Tourist__c>();
        }

        return [
            SELECT Name, Email__c, Gender__c
            FROM Tourist__c
            WHERE Id NOT IN (
                SELECT Tourist__c
                FROM Flight__c
                WHERE Trip__c = :excludeTripId
            ) AND Age__c >= :minAge
            AND Active__c = True
            ORDER BY CreatedDate
            LIMIT :limitSize
            OFFSET :offset
        ];
    }
}