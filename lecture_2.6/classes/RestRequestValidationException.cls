public with sharing class RestRequestValidationException extends Exception {
    private String errorMsg;
    private Integer statusCode;

    public RestRequestValidationException(String errorMsg, Integer statusCode) {
        this.errorMsg = errorMsg;
        this.statusCode = statusCode;
    }

    public override String getMessage() {
        return errorMsg;
    }

    public Integer getStatusCode() {
        return statusCode;
    }
}