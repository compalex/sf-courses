public class TouristService {
    
    public static void markDuplicates(List<Tourist__c> newTourists) {
        if(newTourists == null || newTourists.isEmpty()) {
            return;
        }
        List<String> lastNames = new List<String>();
        
        for(Tourist__c newTourist : newTourists) {
            lastNames.add(newTourist.LastName__c);
        }
        List<Tourist__c> oldTourists = TouristManager.getByLastName(lastNames);
        List<Tourist__c> touristsToUpdate = new List<Tourist__c>();
        
        for(Tourist__c newTourist : newTourists) {
            for(Tourist__c oldTourist : oldTourists) {
                if(newTourist.LastName__c == oldTourist.LastName__c && newTourist.Email__c == oldTourist.Email__c) {
                    newTourist.IsDuplicate__c = true;
                    touristsToUpdate.add(newTourist);
                }
            }
        }
        if(!touristsToUpdate.isEmpty()) {
            update newTourists;
        } 
    }
}