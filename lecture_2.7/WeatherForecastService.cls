public with sharing class WeatherForecastService {

    public static String getForecasts(Decimal latitude, Decimal longitude) {
        Http http = new Http();
        HttpResponse response = http.send(createRequest(latitude, longitude));

        String jsonBody;
        if(response.getStatusCode() == Constants.STATUS_CODE_200) {
            jsonBody = response.getBody();
        } else {
            throw new WeatherForecastException(Constants.WEATHER_FORECAST_EXCEPTION_MSG, response.getStatusCode());
        }

        return jsonBody;
    }

    public static Map<Date, Decimal> parseJSONBodyUntyped(String jsonBody) {
        Map<String, Object> deserializedJSON = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);
        List<Object> allDaysRecords = (List<Object>) deserializedJSON.get(Constants.WEATHER_API_DATA);
        Map<Date, Decimal> tempsByDate = new Map<Date, Decimal>();

        for(Object dayRecords : allDaysRecords) {
            Map<String, Object> castedDayRecords = (Map<String, Object>) dayRecords;
            Date dayDate = Date.valueOf((String) castedDayRecords.get(Constants.WEATHER_API_DATE));
            Decimal temp = (Decimal) castedDayRecords.get(Constants.WEATHER_API_TEMP);
            tempsByDate.put(dayDate, temp);
        }

        return tempsByDate;
    }

    private static HttpRequest createRequest(Decimal latitude, Decimal longitude) {
        HttpRequest request = new HttpRequest();
        String endPoint = Constants.WEATHER_API_URI;
        endPoint += Constants.WEATHER_API_LAT + latitude;
        endPoint += Constants.WEATHER_API_LON + longitude;
        endPoint += Constants.WEATHER_API_KEY;
        request.setEndpoint(endPoint);
        request.setMethod(Constants.HTTP_REQUEST_METHOD_GET);

        return request;
    }
}