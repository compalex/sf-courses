trigger FlightTrigger on Flight__c (before insert, before update) {
    if(FlightTriggerHandler.isFirstTime) {
        FlightTriggerHandler.isFirstTime = false;

        switch on Trigger.operationType {
            when BEFORE_INSERT {
                FlightTriggerHandler.onBeforeInsert(Trigger.new);
            }
            when BEFORE_UPDATE {
                FlightTriggerHandler.onBeforeUpdate(Trigger.newMap);
            }
        }
    }
}