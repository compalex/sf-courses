@IsTest
private class WeatherForecastUpdaterTest {
    private static final String RECORD_NAME = 'Test Record';
    private static final Integer NUM_TO_CREATE = 3;

    @IsTest
    static void testUpdateForecasts() {
        Test.setMock(HttpCalloutMock.class, new WeatherForecastCalloutMock());
        List<Space_Point__c> beforeUpdate = TestDataFactory.createSpacePoints(NUM_TO_CREATE);

        Test.startTest();
            WeatherForecastUpdater.updateForecasts();
        Test.stopTest();

        List<Space_Point__c> afterUpdate = [
            SELECT Id, (SELECT Average_Temperature__c FROM Weather_Daily_Forecasts__r)
            FROM Space_Point__c
        ];

        System.assertNotEquals(null, afterUpdate[0].Weather_Daily_Forecasts__r);
        System.assertEquals(7.2, afterUpdate[0].Weather_Daily_Forecasts__r[0].Average_Temperature__c);
        System.assertEquals(3, afterUpdate.size());
    }

    @IsTest
    static void testUpdateForecasts_forInvalidCallout() {
        Test.setMock(HttpCalloutMock.class, new WeatherForecastCalloutInvalidMock());
        Space_Point__c invalidSpacePoint = new Space_Point__c(
            Name = RECORD_NAME,
            Latitude__c = null,
            Longitude__c = null
        );
        insert invalidSpacePoint;

        Test.startTest();
            WeatherForecastUpdater.updateForecasts();
        Test.stopTest();

        List<Space_Point__c> afterUpdate = [
            SELECT Id, (SELECT Average_Temperature__c FROM Weather_Daily_Forecasts__r)
            FROM Space_Point__c
        ];

        System.assertNotEquals(null, afterUpdate);
        System.assertEquals(true, afterUpdate[0].Weather_Daily_Forecasts__r.isEmpty());
    }
}
