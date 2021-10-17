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
            validateGetRequest(fuzzyName, age);
            List<Tourist__c> tourists = (age == null)
                ? TouristManager.getByFuzzyname(fuzzyName)
                : TouristManager.getByFuzzynameAndAge(fuzzyName, Integer.valueOf(age));
            response.statusCode = Constants.STATUS_CODE_200;
            response.responseBody = Blob.valueOf(JSON.serializePretty(tourists));
        } catch(RestRequestValidationException ex) {
            response.statusCode = ex.getStatusCode();
            response.responseBody = Blob.valueOf(ex.getMessage());
        } catch (Exception ex) {
            response.statusCode = Constants.STATUS_CODE_500;
            response.responseBody = Blob.valueOf(Constants.ERROR_MSG_500);
        }
    }

    @HttpPost
    global static void createTourist(TouristRestWrapper touristWrapper) {
        RestResponse response = RestContext.response;

        try {
            validatePostRequest(touristWrapper.lastName, touristWrapper.email);
            Tourist__c tourist = new Tourist__c(
                    LastName__c = touristWrapper.lastName,
                    Email__c = touristWrapper.email,
                    Birthdate__c = (touristWrapper.birthdate == null) ? null : touristWrapper.getDateBirthdate()
            );
            if(TouristService.isDuplicate(touristWrapper.getDuplicateKey())) {
                response.statusCode = Constants.STATUS_CODE_409;
                response.responseBody = Blob.valueOf(Constants.ERROR_DUPLICATE_EXISTS);
            } else {
                insert tourist;
                response.statusCode = Constants.STATUS_CODE_200;
                response.responseBody = Blob.valueOf(Constants.RESPONSE_SUCCESS);
            }
        } catch(RestRequestValidationException ex) {
            response.statusCode = ex.getStatusCode();
            response.responseBody = Blob.valueOf(ex.getMessage());
        } catch(Exception ex) {
            response.statusCode = Constants.STATUS_CODE_500;
            response.responseBody = Blob.valueOf(Constants.ERROR_MSG_500);
        }
    }

    private static void validateGetRequest(String fuzzyName, String age) {
        if(String.isBlank(fuzzyName)) {
            throw new RestRequestValidationException(Constants.ERROR_MSG_EMPTY_NAME, Constants.STATUS_CODE_404);
        } else if(!(age == null || age.isNumeric())) {
            throw new RestRequestValidationException(Constants.ERROR_MSG_INVALID_AGE, Constants.STATUS_CODE_404);
        }
    }

    private static void validatePostRequest(String lastName, String email) {
        if(String.isBlank(lastName)) {
            throw new RestRequestValidationException(Constants.ERROR_MSG_EMPTY_NAME, Constants.STATUS_CODE_404);
        } else if(String.isBlank(email)) {
            throw new RestRequestValidationException(Constants.ERROR_MSG_EMPTY_EMAIL, Constants.STATUS_CODE_404);
        }
    }
}