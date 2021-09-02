public class NumberUtility {

    public static List<Integer> getPrimes(Integer max) {
        List<Integer> primes = new List<Integer>();
        if(max == null) {
            return primes;
        }
        
        for(Integer i = 1; i <= max; i++) {
            if(isPrime(i)) {
                primes.add(i);
            }
		}
        return primes;
    }
    
    private static Boolean isPrime(Integer num) {
        if(num == null) {
            return false;
        }
        Boolean isPrime = true;
        if(num < 2) {
            isPrime = false;
        } else if(num == 2) {
            isPrime = true;
        } else {
            for(Integer i = 2; i < num; i++) {
                if(Math.mod(num, i) == 0) {
                    isPrime = false;
                }
            }
        }
        return isPrime;
    }
    
    public static List<Integer> getFibos(Integer max) {
        if(max == null) {
            return new List<Integer>();
        }
        Integer i = 1; 
        Integer j = 2;
        Integer temp;
        List<Integer> fibos = new List<Integer> {i, j};
            
        while(i + j <= max) {
            temp = i + j;
            i = j;
            j = temp;
            fibos.add(j);
        }
        return fibos;
    }
    
    public static Boolean isPalindrome(Long numToCheck) {
        if(numToCheck == null) {
			return false;            
        }
        String strToCheck = String.valueOf(numToCheck);
		String reversedStr = strToCheck.reverse();
        return strToCheck == reversedStr;
    }
}