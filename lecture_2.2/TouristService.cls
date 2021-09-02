public class TouristService {
    
    public static void markDuplicates(List<Tourist__c> newTourists) {
        if(newTourists == null || newTourists.isEmpty()) {
            return;
        }
		Boolean areThereAnyDuplicates = false;
        
        for(Tourist__c newTourist : newTourists) {
            Tourist__c existingTourist = [
                SELECT id
                FROM Tourist__c
                WHERE LastName__c = :newTourist.LastName__c
                AND Email__c = :newTourist.Email__c
                LIMIT 1
            ];
            if(existingTourist != null) {
				areThereAnyDuplicates = true;
                newTourist.IsDuplicate__c = true;
            }
        }
		if(areThereAnyDuplicates) {
			update newTourists;
		}
    }
}