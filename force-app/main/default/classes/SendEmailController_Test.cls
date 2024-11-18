/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public  class SendEmailController_Test {
    @TestSetup
    static void setupTestData() {
   
        Account accountRecord = new Account(Name = 'Test');
        insert accountRecord;

        Contact testContact = new Contact(
            LastName = 'TestContact',
            Email = 'testcontact@test.com',
            AccountId = accountRecord.Id
        );
        insert testContact;

        npe5__Affiliation__c affiliation = new npe5__Affiliation__c(
            npe5__Contact__c = testContact.Id,
            Email__c = testContact.Email,
            npe5__Organization__c = accountRecord.Id
        );
        insert affiliation;
        
        Case testCase = new Case(Subject = 'Test Case-0-01');
		insert testCase;
        
    }
    private static List<SendEmailController.EmailRequest> createEmailRequests() {
        Case objCase = [SELECT Id FROM Case WHERE  Subject = 'Test Case-0-01'];
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        SendEmailController.EmailRequest emailRequest = new SendEmailController.EmailRequest();
        emailRequest.toAddress = 'recipient@example.com';
        emailRequest.subject = 'Test Subject';
        emailRequest.plainTextBody = 'Test email body';
        emailRequest.conId = contact.Id;

        return new List<SendEmailController.EmailRequest> { emailRequest };
    }
    @isTest
    static void testSendEmail() {
        // Set up test data
        List<SendEmailController.EmailRequest> requests = createEmailRequests();
        
        // Execute the method
        Test.startTest();
        SendEmailController.sendEmail(requests);
        Test.stopTest();
    }
    
    @IsTest
    static void testGetOrgWideEmailIds() {
        Test.startTest();
        List<OrgWideEmailAddress> orgWideEmails = SendEmailController.getOrgWideEmailIds();
        Test.stopTest();
    }
    
    @IsTest
    static void testGetEmailIds() {
        npe5__Affiliation__c testAffiliation = [SELECT Id,Email__c FROM npe5__Affiliation__c where Email__c='testcontact@test.com'  LIMIT 1];
        Test.startTest();
        List<npe5__Affiliation__c> emailList = SendEmailController.getEmailIds(new List<String>{testAffiliation.Id});
        System.debug('@@emailList'+  emailList);
        Test.stopTest();
        System.assertEquals('testcontact@test.com', emailList[0].Email__c, 'Email should match the inserted test data');
    }
    
    @IsTest
    static void testGetEmailCollectionMap() {
        // Retrieve the inserted affiliation for testing
        npe5__Affiliation__c testAffiliation = [SELECT Id FROM npe5__Affiliation__c LIMIT 1];

        // Test the getEmailCollectionMap method
        Test.startTest();
        Map<Id, String> emailMap = SendEmailController.getEmailCollectionMap(new List<String>{testAffiliation.Id});
        Test.stopTest();
    }
    
     @isTest
    static void testSendEmailWithEmptyList() {
        // Test sending email with an empty list of requests
        Test.startTest();
        SendEmailController.sendEmail(new List<SendEmailController.EmailRequest>());
        Test.stopTest();
        
        // Verify that no email messages were created
        List<EmailMessage> emailMessages = [SELECT Id FROM EmailMessage];
        System.assertEquals(0, emailMessages.size(), 'No EmailMessage records should be created for an empty request list');
    }
    
    @IsTest
    static void testSendMail() {
        // Retrieve the inserted affiliation and OrgWideEmailAddress for testing
        npe5__Affiliation__c testAffiliation = [SELECT Id, Email__c FROM npe5__Affiliation__c where email__c='testcontact@test.com' limit 1];
        OrgWideEmailAddress owea = [SELECT Id,DisplayName,Address FROM OrgWideEmailAddress where DisplayName='TFA Salesforce Support' LIMIT 1];
        List<String> toEmailList = new List<String>{testAffiliation.Email__c};
        String subject = 'Test Subject';
        String htmlBody = '<p>This is a test email.</p>';
        String fileName = 'TestFile.txt';
        String base64Data = EncodingUtil.base64Encode(Blob.valueOf('Test File Content'));
        String fileType = 'text/plain';
        List<String> affiliationIds = new List<String>{testAffiliation.Id};
        
        Test.startTest();
        SendEmailController.sentMail(owea.Id, toEmailList, subject, htmlBody, fileName, base64Data, fileType, affiliationIds,false);
        Test.stopTest();

    }

}