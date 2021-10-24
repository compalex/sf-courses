@IsTest
private class WeatherForecastServiceTest {
    private static final Decimal LATITUDE = 55.55;
    private static final Decimal LONGITUDE = 77.77;

    @IsTest
    static void testGetForecasts() {
        Test.setMock(HttpCalloutMock.class, new WeatherForecastCalloutMock());

        String jsonBody = WeatherForecastService.getForecasts(LATITUDE, LONGITUDE);

        System.assertNotEquals(null, jsonBody);
        System.assertEquals(true, jsonBody.contains(WeatherForecastCalloutMock.jsonBody));
    }

    @IsTest
    static void testGetForecasts_forInvalidParams() {
        Test.setMock(HttpCalloutMock.class, new WeatherForecastCalloutInvalidMock());
        String jsonBody;
        WeatherForecastException exToCatch;

        try {
            jsonBody = WeatherForecastService.getForecasts(null, null);
        } catch (WeatherForecastException ex) {
            exToCatch = ex;
        }

        System.assertEquals(null, jsonBody);
        System.assertEquals(true, exToCatch.getMessage().contains(String.valueOf(Constants.STATUS_CODE_409)));
    }
}
