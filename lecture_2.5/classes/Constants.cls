public class Constants {
    public static final String SPLIT_SYMBOL = ',';
    public static final String ERROR_INVALID_AGE = 'Invalid age!';
    public static final String ERROR_INVALID_START_DATE = 'Invalid start date!';
    public static final String FLIGHT_STATUS_DECLINED = 'Declined';
    public static final String CUSTOM_MDT_TYPES_EMAIL_RECORD = 'Declined_Flights_Email';
    public static final String EMAIL_HTML_HEADER = 'Flights have been deleted for the following tourists:';
    public static final String EMAIL_SUBJECT = 'Flight have been deleted!';
    public static final String EMAIL_SENDER_NAME = 'SFDC courses inc.';
    public static final String EMAIL_TOURIST_ID = '<br>TouristId: ';
    public static final String EMAIL_TOURIST_NUMBER = ', number of Flights deleted: ';
    public static final String JOB_NAME_HALF_THE_HOUR = 'Flight Cleaner Process at Half the Hour';
    public static final String JOB_NAME_ON_THE_HOUR = 'Flight Cleaner Process at On the Hour';
    public static final String CRON_HALF_THE_HOUR = '0 0 * * * ?';
    public static final String CRON_ON_THE_HOUR = '0 30 * * * ?';
    public static final String BATCH_QUERY_LOCATOR =
            'SELECT Id, Tourist__c FROM Flight__c WHERE Status__c = \'Declined\' AND CreatedDate < LAST_N_DAYS:30';
}