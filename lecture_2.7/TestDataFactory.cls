@IsTest
public class TestDataFactory {
    private static final String RECORD_NAME = 'Test Record #';
    private static final String RECORD_EMAIL = 'testtesttest@gmail.com';
    private static final String CRON = '0 30 * * * ?';
    private static final Integer GEOLOCATION_DECIMAL_SCALE = 2;
    private static final Integer MIN_YEAR_OF_BIRTH = 1900;
    private static final Integer MAX_YEAR_OF_BIRTH = 2020;
    private static final Integer MONTH_OF_BIRTH = 11;
    private static final Integer DAY_OF_BIRTH = 11;
    private static final Integer MAX_EMAIL_NUM = 1000000;
    private static final Integer NUM_DAYS_AGO = -50;
    private static final Decimal MIN_LATITUDE = -90.00;
    private static final Decimal MAX_LATITUDE = 90.00;
    private static final Decimal MIN_LONGITUDE = -180.00;
    private static final Decimal MAX_LONGITUDE = 180.00;

    public static List<Tourist__c> createTourists(Integer numToCreate) {
        List<Tourist__c> tourists = new List<Tourist__c>();

        for(Integer i = 0; i < numToCreate; i++) {
            tourists.add(new Tourist__c(
                Name = RECORD_NAME + i,
                LastName__c = RECORD_NAME + i,
                Email__c = RECORD_EMAIL + TestDataUtils.generateRandomInteger(0, MAX_EMAIL_NUM),
                IsDuplicate__c = false,
                Birthdate__c = Date.newInstance(
                        TestDataUtils.generateRandomInteger(MIN_YEAR_OF_BIRTH, MAX_YEAR_OF_BIRTH),
                        MONTH_OF_BIRTH,
                        DAY_OF_BIRTH
                )
            ));
        }

        insert tourists;
        return tourists;
    }

    public static List<Trip__c> createTrips(Integer numToCreate) {
        List<Trip__c> trips = new List<Trip__c>();

        for(Integer i = 0; i < numToCreate; i++) {
            trips.add(new Trip__c(
                Name = RECORD_NAME + i
            ));
        }

        insert trips;
        return trips;
    }

    public static List<Flight__c> createFlights(Integer numToCreate) {
        List<Flight__c> flights = new List<Flight__c>();
        List<Tourist__c> tourists = createTourists(numToCreate);
        List<Trip__c> trips = createTrips(numToCreate);

        for(Integer i = 0; i < numToCreate; i++) {
            flights.add(new Flight__c(
                    Name = RECORD_NAME + i,
                    Tourist__c = tourists.get(i).Id,
                    Trip__c = trips.get(i).Id
            ));
        }

        insert flights;
        return flights;
    }

    public static List<Space_Point__c> createSpacePoints(Integer numToCreate) {
        List<Space_Point__c> spacePoints = new List<Space_Point__c>();

        for(Integer i = 0; i < numToCreate; i++) {
            spacePoints.add(new Space_Point__c(
                Name = RECORD_NAME + i,
                Latitude__c = TestDataUtils.generateRandomDecimal(MIN_LATITUDE, MAX_LATITUDE, GEOLOCATION_DECIMAL_SCALE),
                Longitude__c = TestDataUtils.generateRandomDecimal(MIN_LONGITUDE, MAX_LONGITUDE, GEOLOCATION_DECIMAL_SCALE)
            ));
        }

        insert spacePoints;
        return spacePoints;
    }

    public static List<Tourist__c> createDuplicateTourists(List<Tourist__c> tourists, Integer numToCreate) {
        if(tourists == null || tourists.isEmpty() || numToCreate > tourists.size()) {
            return new List<Tourist__c>();
        }
        List<Tourist__c> duplicateTourists = new List<Tourist__c>();

        while(numToCreate > 0) {
            duplicateTourists.add(new Tourist__c(
                    Name = RECORD_NAME + numToCreate,
                    LastName__c = tourists.get(numToCreate).LastName__c,
                    Email__c = tourists.get(numToCreate).Email__c,
                    IsDuplicate__c = false
            ));
            numToCreate--;
        }

        insert duplicateTourists;
        return duplicateTourists;
    }

    public static List<Flight__c> createOldDeclinedFlights(Integer numToCreate) {
        List<Flight__c> flights = new List<Flight__c>();
        List<Tourist__c> tourists = createTourists(numToCreate);
        List<Trip__c> trips = createTrips(numToCreate);

        for(Integer i = 0; i < numToCreate; i++) {
            Flight__c flight = new Flight__c(
                Name = RECORD_NAME + i,
                Tourist__c = tourists.get(i).Id,
                Trip__c = trips.get(i).Id,
                Status__c = Constants.FLIGHT_STATUS_DECLINED
            );
            flights.add(flight);
        }
        insert flights;

        for(Flight__c flight : flights) {
            Test.setCreatedDate(flight.Id, Datetime.now().addDays(NUM_DAYS_AGO));
        }

        return flights;
    }

    public static Set<Id> createAsyncApexJobs(Integer numToCreate) {
        Set<Id> jobIds = new Set<Id>();

        for(Integer i = 0; i < numToCreate; i++) {
            jobIds.add(Database.executeBatch(new FlightDeleteBatch()));
        }

        return jobIds;
    }
}