public with sharing class WeatherForecastException extends Exception {
    private String msg;
    private Integer statusCode;

    public WeatherForecastException(String msg, Integer statusCode) {
        this.msg = msg;
        this.statusCode = statusCode;
    }

    public override String getMessage() {
        return msg + statusCode;
    }
}