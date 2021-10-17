global class WeatherForecastCalloutMock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();

        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"data":[{"valid_date":"2022-10-15","temp":7.2},{"valid_date":"2022-10-16","temp":7.2}]}');
        response.setStatusCode(200);

        return response; 
    }
}
