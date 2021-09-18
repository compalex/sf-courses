public with sharing class FlightDeleteBatch implements Database.Batchable<sObject>, Database.Stateful, Database.RaisesPlatformEvents {
    private Map<Id, Integer> amountsByTouristIds = new Map<Id, Integer>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                Constants.BATCH_QUERY_LOCATOR);
    }

    public void execute(Database.BatchableContext bc, List<Flight__c> scope) {
        for(Flight__c flight : scope) {
            if(amountsByTouristIds.keySet().contains(flight.Tourist__c)) {
                amountsByTouristIds.put(flight.Tourist__c, amountsByTouristIds.get(flight.Tourist__c) + 1);
            } else {
                amountsByTouristIds.put(flight.Tourist__c, 1);
            }
        }
        delete scope;
    }

    public void finish(Database.BatchableContext bc) {
        EmailUtils.sendEmail(amountsByTouristIds);
    }
}