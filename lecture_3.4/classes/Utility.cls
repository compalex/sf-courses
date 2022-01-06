public with sharing class Utility {

    public static void logError(Exception ex) {
        System.debug(LoggingLevel.ERROR, ex.getLineNumber() + ': ' + ex.getMessage() + '\n' + ex.getStackTraceString());
    }

    public static Boolean isValidId(String stringId) {
        Boolean isValid;

        try {
            Id.valueOf(stringId);
            isValid = true;
        } catch(System.StringException ex) {
            isValid = false;
        } 

        return isValid;
    }
}
