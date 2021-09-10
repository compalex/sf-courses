public with sharing class ExceptionPlayground {

    public static void generateCustomException() {
        throw new CustomException();
    }

    public static void generateRegularException() {
        List<Integer> ints = new List<Integer> {10, 20, 30};
        ints.get(3);
    }

    public static void handleException() {
        try {
            generateCustomException();
            generateRegularException();
        } catch (CustomException ex) {
            System.debug(ex);
        } catch (ListException ex) {
            System.debug(ex);
        }
    }
}