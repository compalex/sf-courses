@IsTest
private class WeatherForecastServiceTest {
    private static final Integer NUM_TO_CREATE = 3;
    private static final Decimal LATITUDE = 55.55;
    private static final Decimal LONGITUDE = 77.77;
    private static final String JSON_SUBSTRING = '{"valid_date":"2022-10-15","temp":7.2}';

    @IsTest
    static void testGetForecasts() {
        Test.setMock(HttpCalloutMock.class, new WeatherForecastCalloutMock());

        String jsonBody = WeatherForecastService.getForecasts(LATITUDE, LONGITUDE);

        System.assertNotEquals(null, jsonBody);
        System.assertEquals(true, jsonBody.contains(JSON_SUBSTRING));
    }

    @IsTest
    static void testUpdateForecasts() {
        Test.setMock(HttpCalloutMock.class, new WeatherForecastCalloutMock());
        List<Space_Point__c> beforeUpdate = TestDataFactory.createSpacePoints(NUM_TO_CREATE);

        Test.startTest();
            WeatherForecastUpdater.updateForecasts();
        Test.stopTest();

        List<Space_Point__c> afterUpdate = [
            SELECT Id, (SELECT Id FROM Weather_Daily_Forecasts__r)
            FROM Space_Point__c
        ];

        System.assertNotEquals(null, afterUpdate.get(0).Weather_Daily_Forecasts__r);
        System.assertNotEquals(7.2, afterUpdate.get(0).Weather_Daily_Forecasts__r.Average_Temperature__c);
        System.assertEquals(3, afterUpdate.size());
    }
}
