@isTest
private class UpdateContactsNumOnAccountBatchableTest {
    
    @TestSetup
    static void testData(){
            List<Account> testAccountList = new List<Account>();
            List<Contact> testContactList = new List<Contact>();
            
            for(integer i = 0; i<3;i++) {
                testAccountList.add(new Account(Name = 'testAccount'+i));
            }
            insert testAccountList;

            for(integer i = 0; i<5;i++) {
                testContactList.add(new Contact(LastName = 'test'+i, AccountId = testAccountList[0].Id));
            }
            for(integer i = 5; i<15;i++) {
                testContactList.add(new Contact(LastName = 'test'+i, AccountId = testAccountList[1].Id));
            }
            insert testContactList;
        }

        private static testMethod void batchTest(){
            Test.startTest();
            UpdateContactsNumOnAccountBatchable batcher = new UpdateContactsNumOnAccountBatchable();
            Id jobid= Database.executeBatch(batcher,2000);
            Test.stopTest();
            List<Account> acctList = [select Id,Number_Of_Contacts__c, (Select Id from Contacts) from Account];
            system.assertEquals(5, acctList[0].Number_Of_Contacts__c);
            system.assertEquals(10, acctList[1].Number_Of_Contacts__c);
            system.assertEquals(0, acctList[2].Number_Of_Contacts__c);
        }

        private static testMethod void scheduleTest(){
            String jobID = null;
            Test.startTest();
            UpdateContactsNumOnAccountSchedulable m = new UpdateContactsNumOnAccountSchedulable();
            String sch = '0 0 22 ? * * *';
            jobID = system.schedule('UpdateContactsNumOnAccountJobTest', sch, m);
            Test.stopTest();
            system.assertNotEquals(null, jobID);
        }
}
