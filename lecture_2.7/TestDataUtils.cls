@IsTest
public class TestDataUtils {

    public static Integer generateRandomInteger(Integer min, Integer max) {
        return (min + (max - min) * Math.random()).intValue();
    }

    public static Decimal generateRandomDecimal(Decimal min, Decimal max, Integer decimalPlaces) {
        return (min + (max - min) * Math.random()).setScale(decimalPlaces);
    }
}