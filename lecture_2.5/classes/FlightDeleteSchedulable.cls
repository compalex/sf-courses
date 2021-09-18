global class FlightDeleteSchedulable implements Schedulable {

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new FlightDeleteBatch());
    }

    //run this method in Anonymous Apex to schedule the FlightDeleteBatch
    public static void scheduleExecutor() {
        FlightDeleteSchedulable batchProcessor = new FlightDeleteSchedulable();
        System.schedule(Constants.JOB_NAME_HALF_THE_HOUR, Constants.CRON_HALF_THE_HOUR, batchProcessor);
        System.schedule(Constants.JOB_NAME_ON_THE_HOUR, Constants.CRON_ON_THE_HOUR, batchProcessor);
    }
}