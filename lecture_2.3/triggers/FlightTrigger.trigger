trigger FlightTrigger on Flight__c (before update, after insert) {
    if(FlightTriggerHandler.isFirstTime) {
        FlightTriggerHandler.isFirstTime = false;

        switch on Trigger.operationType {
            when BEFORE_UPDATE {
                FlightTriggerHandler.onBeforeUpdate(Trigger.newMap);
            }
            when AFTER_INSERT {
                FlightTriggerHandler.onAfterInsert(Trigger.newMap);
            }
        }
    }
}