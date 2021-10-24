global class WeatherForecastCalloutInvalidMock implements HttpCalloutMock {
    global static String jsonBody = 'Script-thrown exception';

    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(jsonBody);
        response.setStatusCode(Constants.STATUS_CODE_409);

        return response; 
    }
}
