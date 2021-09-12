public class TouristService {

    @future
    public static void markDuplicatesAsync(Set<Id> touristIds) {
        if(touristIds == null || touristIds.isEmpty()) {
            return;
        }
        List<Tourist__c> newTourists = TouristManager.getByIds(touristIds);
        Set<String> newDuplicateKeys = new Set<String>();

        for(Tourist__c tourist : newTourists) {
            newDuplicateKeys.add(tourist.Duplicate_Key__c);
        }
        Set<String> existingDuplicateKeys = new Set<String>();

        for(Tourist__c tourist : TouristManager.getByDuplicateKeys(newDuplicateKeys, touristIds)) {
            existingDuplicateKeys.add(tourist.Duplicate_Key__c);
        }
        List<Tourist__c> touristsToUpdate = new List<Tourist__c>();

        for(Tourist__c tourist : newTourists) {
            if(existingDuplicateKeys.contains(tourist.Duplicate_Key__c)) {
                tourist.IsDuplicate__c = true;
                touristsToUpdate.add(tourist);
            }
        }
        update touristsToUpdate;
    }
}