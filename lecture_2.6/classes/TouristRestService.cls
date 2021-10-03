@RestResource(UrlMapping='/Tourist/*')
global with sharing class TouristRestService {
    private static final String REQ_PARAM_FUZZYNAME = 'fuzzyname';
    private static final String REQ_PARAM_AGE = 'age';

    @HttpGet
    global static void getTourists() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String fuzzyName = request.params.get(REQ_PARAM_FUZZYNAME);
        String age = request.params.get(REQ_PARAM_AGE);

        try {
            validateRequest(fuzzyName, age);
        } catch(RestRequestValidationException ex) {
            response.statusCode = ex.getStatusCode();
            response.responseBody = Blob.valueOf(ex.getMessage());
            return;
        }

        List<Tourist__c> tourists;
        if(age == null) {
            tourists = TouristManager.getByFuzzyname(fuzzyName);
        } else {
            tourists = TouristManager.getByFuzzynameAndAge(fuzzyName, Integer.valueOf(age));
        }
        response.statusCode = Constants.STATUS_CODE_200;
        response.responseBody = Blob.valueOf(JSON.serializePretty(tourists));
    }

    @HttpPost
    global static void createTourist() {
        RestResponse response = RestContext.response;
        TouristRestWrapper touristWrapper = (TouristRestWrapper) JSON.deserialize(
                RestContext.request.requestBody.toString(), TouristRestWrapper.class);
        Tourist__c tourist = new Tourist__c(Name = touristWrapper.getName(), Birthdate__c = touristWrapper.getDOB());

        if(TouristService.isDuplicate(tourist)) {
            response.statusCode = Constants.STATUS_CODE_409;
            response.responseBody = Blob.valueOf(Constants.ERROR_DUPLICATE_EXISTS);
        } else {
            insert tourist;
        }
    }

    private static void validateRequest(String fuzzyName, String age) {
        if(String.isBlank(fuzzyName)) {
            throw new RestRequestValidationException(Constants.ERROR_MSG_EMPTY_NAME, Constants.STATUS_CODE_404);
        } else if(!(age == null || age.isNumeric())) {
            throw new RestRequestValidationException(Constants.ERROR_MSG_INVALID_AGE, Constants.STATUS_CODE_404);
        }
    }
}