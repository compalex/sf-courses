trigger BatchApexErrorEventTrigger on BatchApexErrorEvent (after insert) {
    if(BatchApexErrorEventTriggerHandler.isFirstTime) {
        BatchApexErrorEventTriggerHandler.isFirstTime = false;

        switch on Trigger.operationType {
            when AFTER_INSERT {
                BatchApexErrorEventTriggerHandler.onAfterInsert(Trigger.newMap);
            }
        }
    }
}