public with sharing class EmailUtils {

    public static void sendEmail(Map<Id, Integer> amountsByTouristIds) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String> {
                Space_Tourism__mdt.getInstance(Constants.CUSTOM_MDT_TYPES_EMAIL_RECORD).EmailAddress__c
        };
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName(Constants.EMAIL_SENDER_NAME);
        mail.setSubject(Constants.EMAIL_SUBJECT);
        mail.setHtmlBody(getHtmlBody(amountsByTouristIds));
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { mail });
    }

    private static String getHtmlBody(Map<Id, Integer> amountsByTouristIds) {
        String htmlBody = Constants.EMAIL_HTML_HEADER;

        for(Id touristId : amountsByTouristIds.keySet()) {
            htmlBody += Constants.EMAIL_TOURIST_ID + touristId;
            htmlBody += Constants.EMAIL_TOURIST_NUMBER + amountsByTouristIds.get(touristId);
        }
        return htmlBody;
    }
}