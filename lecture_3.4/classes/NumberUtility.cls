public class NumberUtility {

    public static Decimal getDistanceBetweenGeolocations(Decimal lat1, Decimal lon1, Decimal lat2, Decimal lon2) {
        Double dLat = convertDegreesToRadians(lat2-lat1);
        Double dLon = convertDegreesToRadians(lon2-lon1);

        Double x = Math.pow(Math.sin(dLat / 2), 2) + Math.cos(convertDegreesToRadians(lat1)) 
            * Math.cos(convertDegreesToRadians(lat2)) * Math.pow(Math.sin(dLon / 2), 2);

        return (2 * Math.atan2(Math.sqrt(x), Math.sqrt(1-x)) * Constants.EARTH_RADIUS);
    }

    private static Decimal convertDegreesToRadians(Decimal degrees) {
        return (degrees * (Math.PI / 180));
    }
}