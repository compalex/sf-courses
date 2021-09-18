public with sharing class ErrorLogService {

    public static Error_Log__c assembleErrorLog(BatchApexErrorEvent evt) {
        if(evt == null) {
            return null;
        }
        String recordsStr;

        for(String item : evt.JobScope.split(Constants.SPLIT_SYMBOL)) {
            recordsStr = (Id)item + Constants.SPLIT_SYMBOL;
        }
        return new Error_Log__c (
                Error__c = evt.ExceptionType,
                JobId__c = evt.AsyncApexJobId,
                Records__c = recordsSTR
        );
    }
}