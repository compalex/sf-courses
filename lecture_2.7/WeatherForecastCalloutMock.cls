global class WeatherForecastCalloutMock implements HttpCalloutMock {
    global static String jsonBody = '{"data":[{"valid_date":"2022-10-15","temp":7.2},{"valid_date":"2022-10-16","temp":7.2}]}';

    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(jsonBody);
        response.setStatusCode(STATUS_CODE_200);

        return response; 
    }
}
