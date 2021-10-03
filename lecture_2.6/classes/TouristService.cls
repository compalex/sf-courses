public class TouristService {

    @future
    public static void markDuplicatesAsync(Set<Id> touristIds) {
        if(touristIds == null || touristIds.isEmpty()) {
            return;
        }
        Map<String, Tourist__c>  newTouristsByKey = new Map<String, Tourist__c>();
        Map<String, Tourist__c>  existingTouristsByKey = new Map<String, Tourist__c>();

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

    public static boolean isDuplicate(Tourist__c tourist) {
        return !TouristManager.getByDuplicateKey(tourist.Duplicate_Key__c).isEmpty();
    }
}