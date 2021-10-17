public class TouristService {

    @Future
    public static void markDuplicatesAsync(Set<Id> touristIds) {
        if(touristIds == null || touristIds.isEmpty()) {
            return;
        }
        Map<String, Tourist__c> newTouristsByKey = new Map<String, Tourist__c>();
        Map<String, Tourist__c> existingTouristsByKey = new Map<String, Tourist__c>();

        for(Tourist__c tourist : TouristManager.getByIds(touristIds)) {
            newTouristsByKey.put(tourist.Duplicate_Key__c, tourist);
        }

        for(Tourist__c tourist : TouristManager.getByDuplicateKeys(newTouristsByKey.keySet(), touristIds)) {
            existingTouristsByKey.put(tourist.Duplicate_Key__c, tourist);
        }
        newTouristsByKey.keySet().retainAll(existingTouristsByKey.keySet());

        for(Tourist__c tourist : newTouristsByKey.values()) {
            tourist.IsDuplicate__c = true;
        }

        update newTouristsByKey.values();
    }

    public static Boolean isDuplicate(String duplicateKey) {
        if(String.isBlank(duplicateKey)) {
            return false;
        }
        
        return !TouristManager.getByDuplicateKeys(new Set<String>{duplicateKey}, new Set<Id>()).isEmpty();
    }

    public static Integer calculateAge(Date birthdate) {
        if(birthdate == null) {
            return null;
        }

        return Integer.valueOf(birthdate.daysBetween(Date.today()) / Constants.DAYS_IN_YEAR);
    }

    public static String calculateDuplicateKey(String lastName, String email) {
        if(String.isBlank(lastName) || String.isBlank(email)) {
            return null;
        }

        return lastName + email;
    }
}