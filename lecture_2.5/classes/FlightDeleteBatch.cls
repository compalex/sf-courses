global with sharing class FlightDeleteBatch implements Database.Batchable<sObject>, Database.Stateful,
        Database.RaisesPlatformEvents, Schedulable {
    private final String BATCH_QUERY_LOCATOR =
            'SELECT Id, Tourist__c ' +
            'FROM Flight__c ' +
            'WHERE DeleteQueued__c = true';
    private Map<Id, Integer> amountsByTouristIds = new Map<Id, Integer>();

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new FlightDeleteBatch());
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                BATCH_QUERY_LOCATOR);
    }

    public void execute(Database.BatchableContext bc, List<Flight__c> flights) {
        for(Flight__c flight : flights) {
            if(amountsByTouristIds.keySet().contains(flight.Tourist__c)) {
                amountsByTouristIds.put(flight.Tourist__c, amountsByTouristIds.get(flight.Tourist__c) + 1);
            } else {
                amountsByTouristIds.put(flight.Tourist__c, 1);
            }
        }
        delete flights;
    }

    public void finish(Database.BatchableContext bc) {
        EmailUtils.sendEmail(amountsByTouristIds);
    }
}