trigger ContactTrigger on Contact (before insert, before update) {
    ContactTriggerHelper.updateAccountIndustry(trigger.new, trigger.oldMap);

}