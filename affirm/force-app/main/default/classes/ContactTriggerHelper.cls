public with sharing class ContactTriggerHelper {
    public static void updateAccountIndustry(List<Contact> newList, Map<Id, contact> oldMap) {
        Set<Id> acctIdSet = new Set<id>();
        for(Contact newCon : newList) {
            Contact oldCon = null;
            if(oldMap != null && oldMap.containsKey(newCon.Id)) {
                oldCon = oldMap.get(newCon.Id);
            }
            boolean isOrphanContact = newCon.AccountId == null;
            if(oldCon == null && isOrphanContact) {
                continue;
            }
            if(oldCon != null && oldCon.AccountId == newCon.AccountId) {
                continue;
            }
            if(oldCon != null && isOrphanContact) {
                newCon.Account_Industry__c = null;
            }
            acctIdSet.add(newCon.AccountId);
        }

        if(acctIdSet.isEmpty()) {
            return;
        }

        Map<Id, Account> acctMap = new Map<Id, Account>([select Id, Account_Industry__c 
                                    from Account where Id IN : acctIdSet 
                                    and Account_Industry__c != ''
                                    WITH SECURITY_ENFORCED]);

        for(Contact newCon : newList) {
            if(!acctMap.containsKey(newCon.AccountId)) {
                continue;
            }
            newCon.Account_Industry__c =  acctMap.get(newCon.AccountId).Account_Industry__c;
        }
    }
}