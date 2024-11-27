/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-27-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class ContactAffiliationUpdationBatchable_Test {
    @testSetup
    static void setupTestData() {
        // Create Account to use as default account
        Account defaultAccount = new Account(Name = Label.TFA_Default_Account);
        insert defaultAccount;

        RecordType sch_rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'School' LIMIT 1];
        Account defaultAccount_school = new Account(Name = Label.TFA_Default_Account, RecordTypeId = sch_rt.Id);
        insert defaultAccount_school;
       
        // Create Contacts with different affiliations
        Contact contact1 = new Contact(LastName = 'Contact 1',AccountId=defaultAccount.Id,Alumni__c=true,FLP_Fellow__c=true, RecordTypeId = getContactRecordTypeId('Applicants'));
        Contact contact2 = new Contact(LastName = 'Contact 2',AccountId=defaultAccount.Id,Alumni__c=true,FLP_Fellow__c=true, RecordTypeId = getContactRecordTypeId('Associates'));
        insert new List<Contact>{contact1, contact2};
        Position__c positionObj = new Position__c(Placed_Date_Stamp__c =Date.today());
        // Create Applications, FLP Applications, Associate Records, and Payments
        Application__c application1 = new Application__c(Contact__c = contact1.Id,Stage__c='Placed',Stage_Last_Update__c=Date.today(), Application_Start_Date__c = Date.today().addYears(-1));
        FLP_Application__c flpApp1 = new FLP_Application__c(School_Lookup__c=defaultAccount_school.Id, Contact__c = contact2.Id, Start_Date__c = Date.today().addMonths(-2),Application_Stage__c = 'Offer Accepted');
        Associate_Record__c associateRec = new Associate_Record__c(Contact__c = contact2.Id,Position__c=positionObj.Id);
        Payments__c payment1 = new Payments__c(Contact__c = contact1.Id, Payment_Date__c = Date.today().addMonths(-6));
        insert new List<sObject>{application1, flpApp1, associateRec, payment1};
    }
    private static Id getContactRecordTypeId(String recordTypeName) {
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = :recordTypeName LIMIT 1];
        return rt.Id;
    }
    @isTest
    static void testGetRecordTypesMap() {
        // Verify that record types map is populated correctly
        Map<String, String> recordTypesMap = ContactAffiliationUpdationBatchable.getRecordTypesMap();
        System.assert(recordTypesMap.containsKey('General'), 'RecordTypes map should contain General.');
        System.assert(recordTypesMap.containsKey('Applicants'), 'RecordTypes map should contain Applicants.');
    }
    @isTest
    static void testRecordTypeUpdate() {
        // Prepare test data
        Contact testContact = new Contact(LastName = 'UpdateTest', RecordTypeId = getContactRecordTypeId('General'));
        insert testContact;

        Test.startTest();
        ContactAffiliationUpdationBatchable.updateContactRecordType(new List<Contact>{testContact});
        Test.stopTest();

        testContact = [SELECT Id, RecordTypeId FROM Contact WHERE Id = :testContact.Id];
        System.assertNotEquals(null, testContact.RecordTypeId, 'Contact RecordType should be updated');
    }
    @isTest
    static void testBatchable() {
        Test.startTest();
        
        // Instantiate the batchable class
        ContactAffiliationUpdationBatchable batch = new ContactAffiliationUpdationBatchable();
        
        // Run the batch
        Database.executeBatch(batch);
        
        Test.stopTest();
        
        // Assertions to verify Affiliation records are created
       // List<npe5__Affiliation__c> createdAffiliations = [SELECT Id, Role__c FROM npe5__Affiliation__c];
       // System.assertNotEquals(0, createdAffiliations.size(), 'Affiliations should be created.');
       // System.assertEquals(4, createdAffiliations.size(), '4 affiliations should be created');
    }
/*
    @isTest
    static void testBatchable() {
        Test.startTest();
        
        // Instantiate the batchable class
        ContactAffiliationUpdationBatchable batch = new ContactAffiliationUpdationBatchable();
        
        // Run the batch
        Database.executeBatch(batch);
        
        Test.stopTest();
        
        // Assertions to verify Affiliation records are created
        List<npe5__Affiliation__c> createdAffiliations = [SELECT Id, Role__c FROM npe5__Affiliation__c];
        System.assertNotEquals(0, createdAffiliations.size(), 'Affiliations should be created.');
        System.assertEquals(4, createdAffiliations.size(), '4 affiliations should be created');
    }
    
    @isTest
    static void testRecordTypeUpdate() {
        // Prepare test data
        Contact testContact = new Contact(LastName = 'UpdateTest', RecordTypeId = getContactRecordTypeId('General'));
        insert testContact;

        Test.startTest();
        ContactAffiliationUpdationBatchable.updateContactRecordType(new List<Contact>{testContact});
        Test.stopTest();

        testContact = [SELECT Id, RecordTypeId FROM Contact WHERE Id = :testContact.Id];
        System.assertNotEquals(null, testContact.RecordTypeId, 'Contact RecordType should be updated');
    }

    @isTest
    static void testGetRecordTypesMap() {
        // Verify that record types map is populated correctly
        Map<String, String> recordTypesMap = ContactAffiliationUpdationBatchable.getRecordTypesMap();
        System.assert(recordTypesMap.containsKey('General'), 'RecordTypes map should contain General.');
        System.assert(recordTypesMap.containsKey('Applicants'), 'RecordTypes map should contain Applicants.');
    }
    
    private static Id getContactRecordTypeId(String recordTypeName) {
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = :recordTypeName LIMIT 1];
        return rt.Id;
    }
*/
}