
global with sharing class TouristRestWrapper {
    global String lastName { get; set; }
    global String email { get; set; }
    global String birthdate { get; set; }

    public Date getDateBirthdate() {
        if(String.isBlank(birthdate)) {
            return null;
        }
        return Datetime.newInstance(Long.valueOf(birthdate)).date();
    }

    public String getDuplicateKey() {
        return lastName + email;
    }
}