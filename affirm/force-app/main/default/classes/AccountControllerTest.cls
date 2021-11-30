@isTest
public class AccountControllerTest {
    
    @TestSetup
    static void makeData(){
        List<Account> testAccountList = new List<Account>();
        
        for(integer i = 0; i<5;i++) {
            testAccountList.add(new Account(Name = 'testAccount'+i));
        }
        insert testAccountList;
    }

    private static testMethod void getAccountListTest() {
        List<Account> acctList;
        test.startTest();
        acctList = AccountController.getAccountList();
        test.stopTest();
        system.assertEquals(5, acctList.size());
    }

    private static testMethod void fetchAccountDetailsTest() {
        List<Account> acctList = [SELECT Id, Name, Industry, Type, Owner.Name, Owner.SmallPhotoUrl, Owner.FullPhotoUrl 
                                  FROM Account];
        Account acct = null;                          
        test.startTest();
        acct = AccountController.fetchAccountDetails(acctList[0].Id);
        test.stopTest();
        system.assertNotEquals(null, acct);
    }
}
