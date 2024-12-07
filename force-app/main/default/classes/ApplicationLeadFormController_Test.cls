/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class ApplicationLeadFormController_Test {
	@testSetup
    static void testData(){

        List<RecordType> oppRtypes = [Select Name, Id From RecordType where sObjectType = 'Opportunity' and isActive = true and Name = 'University'];

        Opportunity opp = new Opportunity(Name = 'University Opp Test', RecordTypeId = oppRtypes[0].Id);

        Account acc = new Account(Name='Teach for Australia');
        insert acc;

        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType = 'Campaign' and isActive = true and Name = 'Event'];
        Map<String, String> campRT = new Map<String, String> {};
        for (RecordType rt: rtypes) {
            campRT.put(rt.Name, rt.Id);
        }
        
        Campaign camp = new Campaign(name = 'testCampaign', RecordTypeId = campRT.get('Event'));
        INSERT camp;
    }
    
    @isTest
    static void saveLead_Test(){
		Campaign camp = [SELECT Id FROM Campaign LIMIT 1];
        test.startTest();
        //set the mock
        MockClass fakeResponse = new MockClass('Success');
        Test.setMock(HttpCalloutMock.class, fakeResponse);   
        
        ApexPages.StandardController sc = new ApexPages.StandardController(camp);
        
        Lead lead = new Lead(LastName = 'test', Company = 'test', Status = 'Open - Not Contacted');
        //INSERT lead;
        
        ApplicationLeadFormController applicationCtrl = new ApplicationLeadFormController(sc);
        applicationCtrl.ld = lead;
        String check = applicationCtrl.sitekey;
        applicationCtrl.saveLead();
        //con.Sync_to_Pardot__c = false;
        //update con;
        test.stopTest();
        Lead leadRecord = [SELECT Id FROM Lead LIMIT 1];
        CampaignMember campMember = [SELECT Id, CampaignId, leadId FROM CampaignMember LIMIT 1];
        System.assertEquals(camp.Id, campMember.CampaignId);
        System.assertEquals(leadRecord.Id, campMember.leadId);
    }
    
    @isTest
    static void saveLeadSucessFalse_Test(){
		Campaign camp = [SELECT Id FROM Campaign LIMIT 1];
        test.startTest();
        //set the mock
        MockClass fakeResponse = new MockClass('Fail');
        Test.setMock(HttpCalloutMock.class, fakeResponse);   
        
        ApexPages.StandardController sc = new ApexPages.StandardController(camp);
        
        Lead lead = new Lead(LastName = 'test', Company = 'test', Status = 'Open - Not Contacted');
        //INSERT lead;
        
        ApplicationLeadFormController applicationCtrl = new ApplicationLeadFormController(sc);
        applicationCtrl.ld = lead;
        String check = applicationCtrl.sitekey;
        applicationCtrl.saveLead();
        //con.Sync_to_Pardot__c = false;
        //update con;
        test.stopTest();
        List<CampaignMember> campMembers = new List<CampaignMember>([SELECT Id, CampaignId, leadId FROM CampaignMember LIMIT 1]);
        System.assertEquals(0, campMembers.size());
    }
}