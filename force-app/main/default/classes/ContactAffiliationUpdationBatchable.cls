/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-20-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class ContactAffiliationUpdationBatchable implements Database.Batchable<sObject> {

    public static final String OBJECT_CONTACT = 'Contact';
    public static final String RECORDTYPE_GENERAL = 'General';
    public static final Set<String> RECORDTYPE_APPLICABLE = new Set<String>{'Applicants','Associates','Alumni','General'};
    
    global List<Contact> start(Database.BatchableContext BC) {
        List<Contact> contactList= new List<Contact>();
        String soqlQuery = 'SELECT Id, Name, Alumni__c, FLP_Alumni__c, RecordTypeId FROM Contact';
        contactList = Database.query(soqlQuery);
        return contactList;
    }

    global void execute(Database.BatchableContext bc, List<Contact> contactList){

        List<npe5__Affiliation__c> toCreatedAffiliationList = new List<npe5__Affiliation__c>();
        Id accountId = [SELECT Id FROM Account WHERE Name = :Label.TFA_Default_Account LIMIT 1].Id;
        set<Id> contactIdsSet = new set<Id>();
        for(Contact contactObj :contactList){
            contactIdsSet.add(contactObj.Id);
        }
        
      toCreatedAffiliationList = getApplicationList(toCreatedAffiliationList,contactIdsSet,accountId);       
      toCreatedAffiliationList = getFLPApplicationList(toCreatedAffiliationList,contactIdsSet, accountId);
      toCreatedAffiliationList = getIncomingAssociateList(toCreatedAffiliationList,contactIdsSet,accountId);
      toCreatedAffiliationList = getDonarAffiliationList(toCreatedAffiliationList,contactIdsSet,accountId);

        try {
            if(!toCreatedAffiliationList.isEmpty()){
                Database.SaveResult[] results = Database.insert(toCreatedAffiliationList, false);
                for (Database.SaveResult result : results) {
                    if (!result.isSuccess()) {
                        for (Database.Error error : result.getErrors()) {
                            LogUtil.error('execute', error.getMessage() + ' Field-' +  error.getFields());
							system.debug('@toCreatedAffiliationList ' +toCreatedAffiliationList);
                        }
                    }
                }
            }
        } catch (Exception ex) {
            LogUtil.error('execute', ex);
        }
        updateContactRecordType(contactList);
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    
   

    public static List<npe5__Affiliation__c> getApplicationList(List<npe5__Affiliation__c> toCreatedAffiliationList, set<Id> contactIdsSet,Id accountId){

        System.debug('1 getApplicationList');
        for(Application__c application : [SELECT Id, Application_Start_Date__c, Contact__c, Contact__r.Email, Email__c, Contact__r.npe01__HomeEmail__c, Contact__r.AccountId, Contact__r.Alumni__c, Stage_Last_Update__c, Stage__c FROM Application__c WHERE Contact__c IN :contactIdsSet AND Stage__c != 'Unsubmitted Application']){
            npe5__Affiliation__c objAffliation = new npe5__Affiliation__c();
            if(application.Application_Start_Date__c != null){
                objAffliation.npe5__StartDate__c = Date.valueOf(application.Application_Start_Date__c);
            }

            if(application.Stage_Last_Update__c != null){
                Datetime endDateTime = application.Stage_Last_Update__c;
                objAffliation.npe5__EndDate__c = Date.valueOf(endDateTime);
            }
            
            objAffliation.Application__c = application.Id;
            objAffliation.Email__c = application.Email__c;
            objAffliation.npe5__Organization__c = accountId;
            objAffliation.npe5__Contact__c = application.Contact__c;
            objAffliation.Role_Category__c = 'LDP';
            objAffliation.Role__c = 'Applicant';
            objAffliation.remediatedData__c = true;
 			/*if(application.Contact__r.Alumni__c){
                System.debug('application.Contact__r.Alumni__c = TRUE');
                toCreatedAffiliationList = getAlumniList(toCreatedAffiliationList, application, accountId);
            }*/
            toCreatedAffiliationList.add(objAffliation);
           
        }
        
        return toCreatedAffiliationList;
    }
    
  

    public static List<npe5__Affiliation__c> getFLPApplicationList(List<npe5__Affiliation__c> toCreatedAffiliationList,set<Id> contactIdsSet, Id accountId){
        System.debug('getFLPApplicationList');
        List<FLP_Application__c> FLPList = new List<FLP_Application__c>();
        FLPList = [SELECT Id, Start_Date__c, CreatedDate, LastModifiedDate, LastActivityDate, Contact__r.Email, Contact__c, Contact__r.AccountId, Contact__r.npe01__HomeEmail__c, Contact__r.npe01__WorkEmail__c, Application_Stage__c, Contact__r.FLP_Fellow__c, School_Lookup__c FROM FLP_Application__c WHERE Contact__c IN :contactIdsSet ];
        Set<Id> applicationIdSet = new Set<Id>();
        Map<Id, Datetime> flpApplicationHistoryMap = new Map<Id, Datetime>();
        if(!FLPList.isEmpty()){
            for(FLP_Application__c flpApplication :FLPList ){
                applicationIdSet.add(flpApplication.Id);
            }
            if(!applicationIdSet.isEmpty()){
                List<FLP_Application__History > flpApplicationHistoryList = [SELECT Id, ParentId, CreatedDate FROM FLP_Application__History WHERE ParentId IN :applicationIdSet ORDER BY createdDate DESC];
                if(!flpApplicationHistoryList.isEmpty()){
                    for(FLP_Application__History flpApplicationHistory : flpApplicationHistoryList){
                        if(!flpApplicationHistoryMap.containsKey(flpApplicationHistory.ParentId)){
                            flpApplicationHistoryMap.put(flpApplicationHistory.ParentId, flpApplicationHistory.CreatedDate);
                        }
                    }
                }
            }
            for(FLP_Application__c flpApplication :FLPList ){
                npe5__Affiliation__c objAffliation = new npe5__Affiliation__c();
                if(flpApplication.CreatedDate != null){
                    objAffliation.npe5__StartDate__c = Date.valueOf(flpApplication.CreatedDate);
                }
                if(flpApplicationHistoryMap.containsKey(flpApplication.Id)){
                    Datetime endDateTime = flpApplicationHistoryMap.get(flpApplication.Id);
                    objAffliation.npe5__EndDate__c = Date.valueOf(endDateTime);
                    system.debug('objAffliation.npe5__EndDate__c = '+Date.valueOf(endDateTime));
                }
                
                system.debug('2 objAffliation.npe5__EndDate__c = '+objAffliation.npe5__EndDate__c);
                objAffliation.FLP_Application__c = flpApplication.Id;
                objAffliation.Email__c = (flpApplication.Contact__r.npe01__HomeEmail__c != null) ? flpApplication.Contact__r.npe01__HomeEmail__c : flpApplication.Contact__r.npe01__WorkEmail__c;
                objAffliation.npe5__Organization__c = accountId;
                objAffliation.npe5__Contact__c = flpApplication.Contact__c;
                objAffliation.Role_Category__c = 'FLP';
                objAffliation.Role__c = 'Applicant';
                objAffliation.remediatedData__c = true;
                
                toCreatedAffiliationList.add(objAffliation);
                if(flpApplication.Contact__r.FLP_Fellow__c && flpApplication.Application_Stage__c == 'Offer Accepted'){
                    System.debug('flpApplication.Contact__r.FLP_Fellow__c && flpApplication.Application_Stage__c == Offer Accepted = TRUE');
                    toCreatedAffiliationList = getFLPFellowList(toCreatedAffiliationList,flpApplication);
                }
            }
        }
        
        return toCreatedAffiliationList;
    }
    
    public static List<npe5__Affiliation__c> getFLPFellowList(List<npe5__Affiliation__c> toCreatedAffiliationList,FLP_Application__c flpApplicationRecord){
       System.debug('getFLPFellowList');
        System.debug('toCreatedAffiliationList size before flp fellow = ' +toCreatedAffiliationList.size());
        npe5__Affiliation__c objAffliation= new npe5__Affiliation__c();
        if(flpApplicationRecord.Start_Date__c!=null){
            objAffliation.npe5__StartDate__c = Date.valueOf(flpApplicationRecord.Start_Date__c);
            Date endDate = Date.valueOf(flpApplicationRecord.Start_Date__c).addyears(1);
            objAffliation.npe5__EndDate__c = endDate;
        }
        
        objAffliation.FLP_Application__c = flpApplicationRecord.Id;
        objAffliation.Email__c = flpApplicationRecord.Contact__r.npe01__WorkEmail__c; 
        objAffliation.npe5__Organization__c = flpApplicationRecord.School_Lookup__c;
        objAffliation.npe5__Contact__c = flpApplicationRecord.Contact__c;
        objAffliation.Role_Category__c = 'FLP';
        objAffliation.Role__c = 'Fellow';
        objAffliation.remediatedData__c = true;

        toCreatedAffiliationList.add(objAffliation);
        System.debug('toCreatedAffiliationList size after flp fellow = ' +toCreatedAffiliationList.size());
        return toCreatedAffiliationList;
    }

    public static List<npe5__Affiliation__c> getIncomingAssociateList(List<npe5__Affiliation__c> toCreatedAffiliationList,set<Id> contactIdsSet,Id accountId){
        System.debug('getIncomingAssociateList');
        for(Associate_Record__c associateRecord : [SELECT Id,Placed_Date_Stamp__c,Contact__r.npe01__HomeEmail__c,Contact__c, Contact__r.AccountId,Contact__r.Alumni__c,Placement_School__c, Application_ID__c FROM Associate_Record__c WHERE Contact__c IN :contactIdsSet]){
            npe5__Affiliation__c objAffliation= new npe5__Affiliation__c();
            if(associateRecord.Placed_Date_Stamp__c!=null){
                objAffliation.npe5__StartDate__c = Date.valueOf(associateRecord.Placed_Date_Stamp__c);
                Date endDate = Date.valueOf(associateRecord.Placed_Date_Stamp__c).addyears(2);
                endDate = Date.newInstance(endDate.year(), 12, 31);
                objAffliation.npe5__EndDate__c = endDate;

            }
            objAffliation.Application__c = associateRecord.Application_ID__c;
            objAffliation.Incoming_Associate_Record__c = associateRecord.Id;
            objAffliation.Email__c = associateRecord.Contact__r.npe01__HomeEmail__c;
            objAffliation.npe5__Organization__c = associateRecord.Placement_School__c;
            objAffliation.npe5__Contact__c = associateRecord.Contact__c;
            objAffliation.Role_Category__c = 'LDP';
            objAffliation.Role__c = 'Participant';
            objAffliation.remediatedData__c = true;

            toCreatedAffiliationList.add(objAffliation);
            if(associateRecord.Contact__r.Alumni__c){
                System.debug('application.Contact__r.Alumni__c = TRUE');
                toCreatedAffiliationList = getAlumniList(toCreatedAffiliationList, associateRecord.Application_ID__c,objAffliation.npe5__EndDate__c,associateRecord.Contact__c,associateRecord.Contact__r.npe01__HomeEmail__c, accountId);
            }
        }
         
        return toCreatedAffiliationList;
    }
  public static List<npe5__Affiliation__c> getAlumniList(List<npe5__Affiliation__c> toCreatedAffiliationList,Id applicationID,Date StartDate,Id contactId,String personalEmailId,Id accountId){
        npe5__Affiliation__c objAffliation= new npe5__Affiliation__c();
        
        if(StartDate!=null){
            objAffliation.npe5__StartDate__c = Date.valueOf(StartDate);
        }
        objAffliation.npe5__EndDate__c =null;
        objAffliation.Application__c = applicationID;
        objAffliation.Email__c = personalEmailId;
        objAffliation.npe5__Organization__c = accountId;
        objAffliation.npe5__Contact__c = contactId;
        objAffliation.Role_Category__c = 'LDP';
        objAffliation.Role__c = 'Alumni';
        objAffliation.remediatedData__c = true;
        toCreatedAffiliationList.add(objAffliation);
      	system.debug('@getAlumniList ' + toCreatedAffiliationList);
        return toCreatedAffiliationList;
    }
    public static List<npe5__Affiliation__c> getDonarAffiliationList(List<npe5__Affiliation__c> toCreatedAffiliationList,set<Id> contactIdsSet,Id accountId){
        System.debug('getDonarAffiliationList');
        for(Payments__c paymentRecordObj:[SELECT Id, LastModifiedDate, CreatedDate, Contact__r.Email, Contact__c, Contact__r.AccountId, Contact__r.npe01__HomeEmail__c, Payment_Date__c FROM Payments__c WHERE Contact__c IN :contactIdsSet]){
            npe5__Affiliation__c objAffliation= new npe5__Affiliation__c();
            if(paymentRecordObj.CreatedDate != null){
                objAffliation.npe5__StartDate__c = Date.valueOf(paymentRecordObj.CreatedDate);
            }
            objAffliation.npe5__EndDate__c = null;
            objAffliation.Email__c = paymentRecordObj.Contact__r.npe01__HomeEmail__c;
            objAffliation.npe5__Organization__c = accountId;
            objAffliation.npe5__Contact__c = paymentRecordObj.Contact__c;
            objAffliation.Role_Category__c = 'Donor';
            objAffliation.Role__c = '';
            objAffliation.remediatedData__c = true;

            toCreatedAffiliationList.add(objAffliation);
        }    
        return toCreatedAffiliationList;
    }

    public static void updateContactRecordType(List<Contact> contactList){
        Map<String,String> contactRecordTypeMap = getRecordTypesMap();
        List<Contact> contactListToBeUpdated = new List<Contact>();
        for(Contact contactObj:contactList){
            contactObj.RecordTypeId  = getTobeRecordTypeID(contactObj.RecordTypeId,contactRecordTypeMap);
            contactListToBeUpdated.add(contactObj);
        }
        if(!contactListToBeUpdated.isEmpty()){
            try{
                Database.SaveResult[] results = Database.update(contactListToBeUpdated, false);
                for (Database.SaveResult result : results) {
                    if (!result.isSuccess()) {
                        for (Database.Error error : result.getErrors()) {
                            LogUtil.error('updateContactRecordType', error.getMessage() + ' Field-' +  error.getFields());

                        }
                    }
                }
            }catch(Exception ex){
                LogUtil.error('execute', ex);
            }
        }
    }
    public static Map<String,String> getRecordTypesMap(){
        Map<String,String> recordTypesMap = new Map<String,String>();
        for(RecordType recordTypeObj:[SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = : OBJECT_CONTACT AND DeveloperName IN :RECORDTYPE_APPLICABLE]){
            recordTypesMap.put(recordTypeObj.DeveloperName,recordTypeObj.Id);
        }
        return recordTypesMap;
    }

    public static String getTobeRecordTypeID(String recordTypeID,Map<String,String> contactRecordTypeMap){
        List<String> BaseRecordTypeIdList = contactRecordTypeMap.values();
        String generalRecordTypeID = contactRecordTypeMap.get(RECORDTYPE_GENERAL);
        if(!BaseRecordTypeIdList.contains(recordTypeID)){
            return  generalRecordTypeID;
        }else{
            return recordTypeID;
        }
           
    }


}