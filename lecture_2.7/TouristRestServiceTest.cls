@IsTest
private class TouristRestServiceTest {
    private static final String TOURIST_LAST_NAME = 'Daniels';
    private static final String TOURIST_EMAIL = 'dan@gmail.com';
    private static final String TOURIST_BIRTHDATE = '800674336000';
    private static final String FUZZYNAME = 'fuzzyname';
    private static final Integer NUM_TO_CREATE = 1;

    @IsTest
    static void testGetTourists() {
        Tourist__c tourist = TestDataFactory.createTourists(NUM_TO_CREATE)[0];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = Constants.HTTP_REQUEST_METHOD_GET;
        req.params.put(FUZZYNAME, tourist.Name);
        req.params.put('age', String.valueOf(TouristService.calculateAge(tourist.Birthdate__c)));

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
            TouristRestService.getTourists();
        Test.stopTest();

        System.assertEquals('[ ]', res.responseBody.toString());
        System.assertEquals(Constants.STATUS_CODE_200, res.statusCode);
    }

    @IsTest
    static void testGetTourists_forEmptyFuzzyname() {
        List<Tourist__c> tourists = TestDataFactory.createTourists(NUM_TO_CREATE);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = Constants.HTTP_REQUEST_METHOD_GET;
        req.params.put(FUZZYNAME, '');

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
            TouristRestService.getTourists();
        Test.stopTest();

        System.assertEquals(Constants.ERROR_MSG_EMPTY_NAME, res.responseBody.toString());
        System.assertEquals(Constants.STATUS_CODE_404, res.statusCode);
    }

    @IsTest
    static void testCreateTourists() {
        RestResponse res = new RestResponse();

        TouristRestWrapper touristWrapper = new TouristRestWrapper();
        touristWrapper.lastName = TOURIST_LAST_NAME;
        touristWrapper.email = TOURIST_EMAIL;
        touristWrapper.birthdate = TOURIST_BIRTHDATE;

        Test.startTest();
            RestContext.response = res;
            TouristRestService.createTourist(touristWrapper);
        Test.stopTest();

        List<Tourist__c> tourists = [
            SELECT LastName__c, Email__c, Birthdate__c
            FROM Tourist__c
        ];

        System.assertNotEquals(null, tourists);
        System.assertEquals(TOURIST_LAST_NAME, tourists.get(0).LastName__c);
        System.assertEquals(TOURIST_EMAIL, tourists.get(0).Email__c);
        System.assertEquals(touristWrapper.getDateBirthdate(), tourists.get(0).Birthdate__c);
        System.assertEquals(Constants.STATUS_CODE_200, res.statusCode);
    }

    @IsTest
    static void testCreateTourist_forBlankLastName() {
        RestResponse res = new RestResponse();

        TouristRestWrapper touristWrapper = new TouristRestWrapper();
        touristWrapper.lastName = null;
        touristWrapper.email = TOURIST_EMAIL;
        touristWrapper.birthdate = TOURIST_BIRTHDATE;

        Test.startTest();
            RestContext.response = res;
            TouristRestService.createTourist(touristWrapper);
        Test.stopTest();

        List<Tourist__c> tourists = [
            SELECT LastName__c, Email__c, Birthdate__c
            FROM Tourist__c
        ];

        System.assertEquals(true, tourists.isEmpty());
        System.assertEquals(Constants.STATUS_CODE_404, res.statusCode);
    }
}
