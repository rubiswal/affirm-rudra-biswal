public with sharing class AccountController {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        return [
            SELECT Id, Name
            FROM Account
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }

    @AuraEnabled
    public static Account fetchAccountDetails(string acctId) {
        return [
            SELECT Id, Name, Industry, Type, Owner.Name, Owner.SmallPhotoUrl, Owner.FullPhotoUrl 
            FROM Account
            WHERE Id = :acctId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
    }
}
