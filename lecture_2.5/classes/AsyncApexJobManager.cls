public with sharing class AsyncApexJobManager {

    public static List<AsyncApexJob> getByIds(Set<Id> ids) {
        if(ids == null || ids.isEmpty()) {
            return new List<AsyncApexJob>();
        }

        return [
            SELECT Id, ApexClass.Name
            FROM AsyncApexJob
            WHERE Id IN :ids
        ];
    }
}