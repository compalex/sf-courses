public inherited sharing class SendOfferController {
    
    @AuraEnabled(cacheable=true)
    public static void sendEmailOffer(String subject, String body, String toAddress) {
        if(String.isBlank(subject) || String.isBlank(body) || String.isBlank(toAddress)) {
            throw new AuraHandledException(Label.ServerError);
        }

        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{toAddress});
            mail.setSubject(subject);
            mail.setHtmlBody(body);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}
