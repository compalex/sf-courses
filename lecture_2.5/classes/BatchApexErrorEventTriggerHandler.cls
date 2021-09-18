public with sharing class BatchApexErrorEventTriggerHandler {
    public static Boolean isFirstTime = true;

    public static void onAfterInsert(Map<Id, BatchApexErrorEvent> newMap) {
        Set<Id> asyncApexJobIds = new Set<Id> ();

        for(BatchApexErrorEvent evt : newMap.values()){
            asyncApexJobIds.add(evt.AsyncApexJobId);
        }
        Map<Id, AsyncApexJob> jobs = new Map<Id, AsyncApexJob> (
            AsyncApexJobManager.getByIds(asyncApexJobIds)
        );
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();

        for(BatchApexErrorEvent evt : newMap.values()) {
            if(jobs.get(evt.AsyncApexJobId).ApexClass.Name == FlightDeleteBatch.class.getName()) {
                errorLogs.add(ErrorLogService.assembleErrorLog(evt));
            }
        }
        insert errorLogs;
    }
}