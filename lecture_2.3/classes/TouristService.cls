public class TouristService {
    
    public static void markDuplicates(List<Tourist__c> newTourists) {
        if(newTourists == null || newTourists.isEmpty()) {
            return;
        }
        Set<String> lastNames = new Set<String>();
        
        for(Tourist__c newTourist : newTourists) {
            lastNames.add(newTourist.LastName__c);
        }
        List<Tourist__c> sameLastNameTourists = TouristManager.getByLastName(lastNames);

        for(Tourist__c newTourist : newTourists) {
            if(isDuplicate(newTourist, sameLastNameTourists)) {
                newTourist.IsDuplicate__c = true;
            }
        }
    }

    private static Boolean isDuplicate(Tourist__c newTourist, List<Tourist__c> sameLastNameTourists) {
        for(Tourist__c existingTourist : sameLastNameTourists) {
            if(newTourist.Email__c == existingTourist.Email__c) {
                return true;
            }
        }
        return false;
    }
}
