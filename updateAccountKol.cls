/*
Created By   : Devraj Tomar
Description  : Update related account Kol field when Kol field on contact changes through delete, insert, undelete, update
Created Date : 9th oct 2018
*/
public class updateAccountKol {
    /*
    Method Description: Update Primary Account Kol field(Checkbox on Account)
    					when Contact is Created with Kol(Checkbox field on Contact) Checked
    Param1:				Map(Key as Contact Id and value as Contact) of contacts which is created
    */
    public static void updateAccountKolOnConInsert(Map<Id,Contact> ConMap)
    {
        List<Account> accountUpdateList = new List<Account>();
        Set<Id> accConId=new Set<Id>() ;
        for(contact cont : ConMap.values()){
            if(cont.AccountId != null && cont.KOL__c == True)
                accConId.add(cont.AccountId);
        }
        if(!accConId.isEmpty()){
            for(Account acc : [Select Id,Kol_Cere__c from Account where Id IN: accConId]){
                if(acc.Kol_Cere__c == false){
                    acc.Kol_Cere__c=True;
                    accountUpdateList.add(acc);
                }
            }
        }
        try{
            if(accountUpdateList.size() > 0)
                Database.update(accountUpdateList);
        }
        catch(System.DMLException e)
        {  
           e.setMessage('Account is not updated because there is an Exception in Contact insertion'); 
        }
    }
    /*
    Method Description: Update Primary Account Kol field(Checkbox on Account)
    					when Contact is Deleted.
    Param1:				Map(Key as Contact Id and value as Contact) of contacts which has been Deleted
    */
    public static void updateAccountKolOnConDelete(Map<Id,Contact> delConList){
        List<Account> accountUpdateList = new List<Account>();
        Set<Id> accConId=new Set<Id>();
        for(contact cont : delConList.values()){
            if(cont.AccountId != null && cont.KOL__c ==true)
                accConId.add(cont.AccountId);
        }
        updateAccountKol(accConId);
    }
    /*
    Method Description: Update Primary Account Kol field(Checkbox on Account)
    					when Contact is Updated or undeleted.
    Param1:				Map(Key as Contact Id and value as Contact) of contacts which is Updated or undeleted.
    */
    public static void updateAccountKolOnConUpdateUndelete(Map<Id,Contact> unDelConList){
        List<Account> accountUpdateList = new List<Account>();
        Set<Id> accConId=new Set<Id>();
        for(contact cont : unDelConList.values()){
            if(cont.AccountId != null)
                accConId.add(cont.AccountId);
        }
        updateAccountKol(accConId);
    }
    /*
    Method Description: ReUsable code to Update Account Kol field
    Param1:				Set of Account Ids which need to be updated
    */
    public static void updateAccountKol(Set<Id> accIds){
        List<Account> accountUpdateList = new List<Account>();
        if(!accIds.isEmpty()){
            for(Account acc : [Select id,Kol_cere__c, (select id from Contacts where Kol__c = true) from Account where Id IN: accIds]){
                if(acc.Contacts.size() == 0){
                    acc.Kol_cere__c=false;
                    accountUpdateList.add(acc);
                    System.debug('inside if');
                }
                else if(acc.Contacts.size() > 0){
                    acc.Kol_cere__c=True;
                    accountUpdateList.add(acc);
                    System.debug('inside Else if');
                }
            }
        }
        try{
            if(accountUpdateList.size() > 0){
                Database.update(accountUpdateList);
            }
        }
        catch(System.DMLException e)
        {
           e.setMessage('Account is not updated because there is an Exception in Contact update/Undelete');
        }
    }
}