@isTest 
private class ContactTriggerTest {

    @TestSetup
    static void makeData(){
        List<Account> testAccountList = new List<Account>();
        Account acct1 = new Account();
        acct1.Name = 'Test Account1';
        acct1.Account_Industry__c = 'Finance';
        testAccountList.add(acct1);
        Account acct2 = new Account();
        acct2.Name = 'Test2 Account1';
        testAccountList.add(acct2);

        insert testAccountList;
    }

    static testMethod void updateAccountIndustryPossitiveTest100() {
        List<Account> acctList = [select Id, Account_Industry__c from Account];
        Contact con = new Contact(LastName = 'LastName100',
                                  AccountId = acctList[0].Id
                                 );

        test.startTest();
        insert con;
        test.stopTest();

        List<Contact> newCon = [select Id, Account_Industry__c from contact where Id = :con.Id];
        system.assertEquals(acctList[0].Account_Industry__c, newCon[0].Account_Industry__c);
    }

    static testMethod void updateAccountIndustryNegativeTest200() {
        List<Account> acctList = [select Id, Account_Industry__c from Account];
        Contact con = new Contact(LastName = 'LastName100',
                                  AccountId = acctList[1].Id
                                 );

        test.startTest();
        insert con;
        test.stopTest();

        List<Contact> newCon = [select Id, Account_Industry__c from contact where Id = :con.Id];
        system.assertEquals(null, newCon[0].Account_Industry__c);
    }

    static testMethod void updateAccountIndustryTest300() {
        List<Account> acctList = [select Id, Account_Industry__c from Account];
        Contact con = new Contact(LastName = 'LastName100',
                                  AccountId = null
                                );

        test.startTest();
        insert con;
        test.stopTest();

        List<Contact> newCon = [select Id, Account_Industry__c from contact where Id = :con.Id];
        system.assertEquals(null, newCon[0].Account_Industry__c);
    }

    static testMethod void updateAccountIndustryTest400() {
        List<Account> acctList = [select Id, Account_Industry__c from Account];
        Contact con = new Contact(LastName = 'LastName100',
                                  AccountId = null
                                );
        insert con;
        
        List<Contact> insertedCon = [select Id, Account_Industry__c from contact where Id = :con.Id];
        system.assertEquals(null, insertedCon[0].Account_Industry__c);
        
        test.startTest();
        con.AccountId = acctList[0].Id;
        update con;
        test.stopTest();

        List<Contact> newCon = [select Id, Account_Industry__c from contact where Id = :con.Id];
        system.assertEquals(acctList[0].Account_Industry__c, newCon[0].Account_Industry__c);
    }
}