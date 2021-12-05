public with sharing class ContentDocumentLinkManager {

    public static List<ContentDocumentLink> getByTripId(Id tripId) {
        if(tripId == null) {
            return new List<ContentDocumentLink>();
        }

        return [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :tripId
        ];
    }
}
