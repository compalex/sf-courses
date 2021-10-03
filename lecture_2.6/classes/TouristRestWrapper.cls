global with sharing class TouristRestWrapper {
    private String name;
    private String birthdate;

    public String getName() {
        return name;
    }

    public Date getDOB() {
        return Datetime.newInstance(Long.valueOf(birthdate)).date();
    }
}