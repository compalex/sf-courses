trigger TouristTrigger on Tourist__c (before insert, before update) {
    if(TouristTriggerHandler.isFirstTime) {
        TouristTriggerHandler.isFirstTime = false;

        switch on Trigger.operationType {
            when BEFORE_INSERT {
                TouristTriggerHandler.onBeforeInsert(Trigger.new);
            }
            when BEFORE_UPDATE {
                TouristTriggerHandler.onBeforeUpdate(Trigger.new);
            }
        }
    }
}