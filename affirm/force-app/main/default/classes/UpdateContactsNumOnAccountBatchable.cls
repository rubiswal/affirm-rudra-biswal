public class UpdateContactsNumOnAccountBatchable implements Database.Batchable<sObject>, Database.Stateful{
    set<id> failedIdSet = new Set<Id>();
    public Database.QueryLocator start(Database.BatchableContext BC){
      // We can write the query here or we can maintain the query in Custom Metadata for respective batch
        string query = 'select Id,Number_Of_Contacts__c, (Select Id from Contacts) from Account';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Account> scope){
        List<Account> updatedAccountList = new List<Account>();
        for(Account acct : scope){
            updatedAccountList.add(
            new Account(Id=acct.Id, Number_Of_Contacts__c = acct.contacts.size())
            );
        }

        try {
            if(!updatedAccountList.isEmpty()) {
                Database.SaveResult[] result = Database.update(updatedAccountList,false);
                for(Integer i=0; i < result.size(); i++) {
                    if(result.get(i).isSuccess()) {
                        System.debug('Records are updated Successfully');
                    } 
                    else if(!result.get(i).isSuccess()) {
                        Database.Error errors =  result.get(i).getErrors().get(0);
                        System.debug('Error Occurs While Processing The Record'+errors.getMessage());
                        System.debug('Failure Record Ids While Updating'+result.get(i).Id);
                        failedIdSet.add(result.get(i).Id);
                    }
                }
            }
        } catch(Exception ex) {
            system.debug('Error');
        }
        
        
    }

    public void finish(Database.BatchableContext BC){
        // We can notofy the failed records here via Email, Chatter.
    }
}