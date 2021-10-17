@IsTest
private class AsyncApexJobManagerTest {
    private static final Integer NUM_TO_CREATE = 10;

    @IsTest
    static void testGetByIds() {
        Test.startTest();
            Set<Id> jobsFromFactory = TestDataFactory.createAsyncApexJobs(NUM_TO_CREATE);
            Map<Id, AsyncApexJob> jobsFromDB = new Map<Id, AsyncApexJob>(AsyncApexJobManager.getByIds(jobsFromFactory));
        Test.stopTest();

        System.assertNotEquals(null, jobsFromDB);
        System.assertEquals(NUM_TO_CREATE, jobsFromFactory.size());
        System.assertEquals(NUM_TO_CREATE, jobsFromDB.size());
        System.assertEquals(jobsFromFactory, jobsFromDB.keySet());
    }

    @IsTest
    static void testGetByIds_forNull() {
        List<AsyncApexJob> jobs = AsyncApexJobManager.getByIds(null);
        System.assertEquals(true, jobs.isEmpty());
    }

    @IsTest
    static void testGetByIds_forEmptiness() {
        List<AsyncApexJob> jobs = AsyncApexJobManager.getByIds(new Set<Id>());
        System.assertEquals(true, jobs.isEmpty());
    }
}