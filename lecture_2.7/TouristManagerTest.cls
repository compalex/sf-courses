@IsTest
private class TouristManagerTest {
    private static final Integer NUM_TO_CREATE = 10;
    private static Map<Id, Tourist__c> touristsFromFactory;

    static {
        touristsFromFactory = new Map<Id, Tourist__c>(TestDataFactory.createTourists(NUM_TO_CREATE));
    }

    @IsTest
    static void testGetByIds() {
        Map<Id, Tourist__c> touristsFromDB = new Map<Id, Tourist__c>(TouristManager.getByIds(touristsFromFactory.keySet()));

        System.assertNotEquals(null, touristsFromDB);
        System.assertEquals(NUM_TO_CREATE, touristsFromDB.size());
        System.assertEquals(true, touristsFromFactory.keySet().containsAll(touristsFromDB.keySet()));
    }

    @IsTest
    static void testGetByIds_forNull() {
        List<Tourist__c> tourists = TouristManager.getByIds(null);
        System.assertEquals(true, tourists.isEmpty());
    }

    @IsTest
    static void testGetByIds_forEmptiness() {
        List<Tourist__c> tourists = TouristManager.getByIds(new Set<Id>());
        System.assertEquals(true, tourists.isEmpty());
    }

    @IsTest
    static void testGetByDuplicateKeys() {
        Set<String> duplicateKeys = new Set<String>();
        Set<Id> excludeIds = new Set<Id>();

        for(Integer i = 0; i < NUM_TO_CREATE; i++) {
            duplicateKeys.add(TouristService.calculateDuplicateKey(
                    touristsFromFactory.values()[i].LastName__c,
                    touristsFromFactory.values()[i].Email__c
            ));
        }
        excludeIds.add(touristsFromFactory.values()[0].Id);
        Map<Id, Tourist__c> touristsFromDB = new Map<Id, Tourist__c>(TouristManager.getByDuplicateKeys(duplicateKeys, excludeIds));

        System.assertNotEquals(null, touristsFromDB);
        System.assertEquals(NUM_TO_CREATE - 1, touristsFromDB.size());
        System.assertEquals(true, touristsFromFactory.keySet().containsAll(touristsFromDB.keySet()));
        System.assertEquals(false, touristsFromDB.keySet().containsAll(excludeIds));
    }

    @IsTest
    static void testGetByFuzzyname() {
        Test.setFixedSearchResults(new List<Id>{touristsFromFactory.values()[0].Id});
        List<Tourist__c> touristsFromDB = TouristManager.getByFuzzyname(touristsFromFactory.values()[0].Name);

        System.assertNotEquals(null, touristsFromDB);
        System.assertNotEquals(null, touristsFromDB[0].Name);
        System.assertEquals(touristsFromFactory.values()[0].Name, touristsFromDB[0].Name);
        System.assertEquals(true, touristsFromFactory.keySet().contains(touristsFromDB[0].Id));
    }

    @IsTest
    static void testGetByFuzzynameAndAge() {
        Test.setFixedSearchResults(new List<Id>{touristsFromFactory.values()[0].Id});
        List<Tourist__c> touristsFromDB = TouristManager.getByFuzzynameAndAge(
                touristsFromFactory.values()[0].Name,
                TouristService.calculateAge(touristsFromFactory.values()[0].Birthdate__c)
        );

        System.assertNotEquals(null, touristsFromDB);
        System.assertEquals(false, touristsFromDB.isEmpty());
        System.assertEquals(touristsFromFactory.values()[0].Name, touristsFromDB[0].Name);
        System.assertEquals(
                TouristService.calculateAge(touristsFromFactory.values()[0].Birthdate__c),
                touristsFromDB[0].Age__c
        );
    }
}