@IsTest
public class TestDataUtils {

    public static Integer generateRandomInteger(Integer min, Integer max) {
        return (min + (max - min) * Math.random()).intValue();
    }

    public static Decimal generateRandomDecimal(Decimal min, Decimal max, Integer decimalPlaces) {
        return (min + (max - min) * Math.random()).setScale(decimalPlaces);
    }

    public static List<Tourist__c> getUnvalidTourists(List<Tourist__c> tourists, Integer age) {
        List<Tourist__c> unvalidTourists = new List<Tourist__c>();

        for(Tourist__c tourist : tourists) {
            if(tourist.Age__c < age) {
                unvalidTourists.add(tourist);
            }
        }

        return unvalidTourists;
    }
}