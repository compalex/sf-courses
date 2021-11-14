@IsTest
private class WeatherForecastUpdaterTest {
    private static final String RECORD_NAME = 'Test Record';
    private static final Integer NUM_TO_CREATE = 3;

    @IsTest
    static void testUpdateForecasts() {
        Test.setMock(HttpCalloutMock.class, new WeatherForecastCalloutMock());
        TestDataFactory.createSpacePoints(NUM_TO_CREATE);

        Test.startTest();
            WeatherForecastUpdater.updateForecasts();
        Test.stopTest();

        List<Space_Point__c> spacePoints = [
            SELECT Id, (SELECT Average_Temperature__c FROM Weather_Daily_Forecasts__r)
            FROM Space_Point__c
        ];

        System.assertEquals(3, spacePoints.size());
        System.assertEquals(2, spacePoints[0].Weather_Daily_Forecasts__r.size());
        System.assertEquals(7.2, spacePoints[0].Weather_Daily_Forecasts__r[0].Average_Temperature__c);
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

        List<Space_Point__c> spacePoints = [
            SELECT Id, (SELECT Average_Temperature__c FROM Weather_Daily_Forecasts__r)
            FROM Space_Point__c
        ];

        System.assertEquals(true, spacePoints[0].Weather_Daily_Forecasts__r.isEmpty());
    }
}
