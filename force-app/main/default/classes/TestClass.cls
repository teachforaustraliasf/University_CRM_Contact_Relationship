/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-27-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestClass {

    public class TestException extends Exception {}

    @testSetup
    static void setup() {
        // Anything in here will be executed once for the entire class, and rolled back after the class is done.
        // If a subsequent test method modifies any records created here, they will be rolled back for the next test method.
        INSERT new Account(Type = 'University', Name = 'Test University');
        INSERT new ApplicationFormRound__c(StartTime__c = System.now().addDays(-1), EndTime__c = System.now().addDays(1), Name = 'Test Round');
    }

    // @isTest
    // public static void sessionTest() { // Session Class tests
    //     String key = 'x';
	//
    //     Test.startTest();
	//
    //     Session session = new Session();
	//
    //     String str;
    //     session.set(key, str);
    //     str = '';
    //     session.set(key, str);
	//
    //     Boolean bool;
    //     session.set(key, bool);
    //     bool = true;
    //     session.set(key, bool);
	//
    //     List<String> lstr;
    //     session.set(key, lstr);
    //     lstr = new List<String>{'', ''};
    //     session.set(key, lstr);
	//
    //     session.get(key);
    //     session.unset(key);
	//
    //     session.saveSession();
	//
    //     session.destroy();
    //     session.nuke();
	//
    //     // ensure no errors thrown when getting a null value - should return an empty string
    //     String t = null;
    //     t = session.get(t);
    //     System.assertEquals('', t);
	//
    //     Test.stopTest();
    // }

    /* START APPLICATIONFORM TESTS */

    // @isTest
    // public static void ApplicationForm_Controller_Test() {
    //     Test.setCurrentPage(Page.ApplicationForm_Preapp1);
	//
    //     ApplicationForm_Controller controller = new ApplicationForm_PreApp1_Controller();
	//
    //     controller.initPage();
	//
    //     Test.startTest();
	//
    //     System.assertEquals(Page.ApplicationForm_Preapp1.getUrl(), controller.getPageByName('applicationform_preapp1').getUrl());
    //     System.assertEquals(new PageReference('nosuchpage').getUrl(), controller.getPageByName('nosuchpage').getUrl());
    //     System.assertEquals(null, controller.getPageByName(null));
	//
    //     System.assertEquals(true, controller.isValidEmail('example@example.com'));
    //     System.assertEquals(false, controller.isValidEmail('example@example@com'));
    //     System.assertEquals(false, controller.isValidEmail(null));
	//
    //     controller.loadSessionFromDB(new Opportunity(
    //         // DATE
    //         preapp2_Graduation_Date__c = System.today(),
    //         // BOOLEAN
    //         step5_StillCurrent1__c = true,
    //         // TEXTAREA
    //         step5_WhyDoYouWishToParticipate__c = 'long test text',
    //         // MULTIPICKLIST
    //         step6_Heritage__c = 'Australian;New Zealand'
    //     ));
    //     controller.loadFormDataFromSession();
    //     controller.saveFormDataToSession(true);
    //     controller.previousStep();
    //     controller.saveForLater();
    //     ApplicationForm_Controller.selectStar('Opportunity');
    //     controller.getDaySelectOptions();
    //     controller.getMonthSelectOptions();
    //     controller.getYearSelectOptions();
    //     try {
    //         throw new TestException('Test Exception.');
    //     } catch (Exception e) {
    //         controller.sendErrorEmail(e);
    //     }
    //     controller.isValid();
	//
    //     Test.stopTest();
    // }

    // public static void ApplicationForm_PreApp1_Controller_SessionSetup(Session s) {
    //     s.set('preapp1_PermanentResidency',  'Yes');
    //     s.set('preapp1_CompletedDegree',  'Yes');
    //     s.set('preapp1_Work_in_TFA_regions',  'Yes');
    //     s.set('preapp1_ReadAgreeTerms',  'Yes');
    // }

    // @isTest
    // public static void ApplicationForm_PreApp1_Controller_Test() {
    //     Test.setCurrentPage(Page.ApplicationForm_Preapp1);
	//
    //     System.assert(ApplicationForm_Control.ApplicationsOpen());
    //     System.assertEquals('Test Round', ApplicationForm_Control.ApplicationRoundName());
	//
    //     ApplicationForm_PreApp1_Controller controller = new ApplicationForm_PreApp1_Controller();
	//
    //     controller.initPage();
	//
    //     // Everything is invalid
    //     controller.isValid();
	//
    //     // Valid values
    //     ApplicationForm_PreApp1_Controller_SessionSetup(controller.session);
    //     controller.loadFormDataFromSession();
    //     controller.isValid();
	//
    //     System.debug(controller.errorMessages);
    //     System.assertEquals(false, controller.showError);
	//
    //     controller.nextStep();
	//
    // }

    // public static void ApplicationForm_PreApp2_Controller_SessionSetup(Session s) {
    //     Id test_university_id = [SELECT Id FROM Account WHERE Name = 'Test University' LIMIT 1][0].Id;
	//
    //     s.set('preapp2_Email', 'example@example.com');
    //     s.set('preapp2_Graduation_Date_Month', '1');
    //     s.set('preapp2_Graduation_Date_Year', '2011');
	//
    //     s.set('preapp2_Title', 'b');
    //     s.set('preapp2_First_Name', 'b');
    //     s.set('preapp2_Preferred_Name', 'b');
    //     s.set('preapp2_Surname', 'b');
    //     s.set('preapp2_Address_Line_1', 'b');
    //     s.set('preapp2_Suburb', 'b');
    //     s.set('preapp2_State', 'b');
    //     s.set('preapp2_Postcode', 'b');
    //     s.set('preapp2_Mobile_Number', 'a');
    //     s.set('preapp2_Alternate_Number', 'b');
    //     s.set('preapp2_Hear_About_Us_1', 'Social Media');
    //     s.set('preapp2_University', test_university_id);
    //     s.set('preapp2_Current_Situation', 'a');
    //     s.set('preapp2_Degree_Specialisation', 'special');
    //     s.set('preapp2_Previous_Meeting', 'No');
    //     s.set('preapp2_PreviouslyApplied', 'No');
    //     s.set('preApp2_Hear_About_Us_1', 'Social Media');
    //     s.set('preapp2_Hear_About_Us_2_SocialMedia', 'Other');
	//
    //     s.set('preapp2_Mobile_Number', '123');
    //     s.set('preapp2_Alternate_Number', '456');
	//
    //     s.set('preApp2_Hear_About_Us_1', 'Word of Mouth');
    //     s.set('preapp2_Hear_About_Us_2_WordOfMouth', 'Other');
	//
    //     s.set('preapp2_Previous_Meeting', 'Yes');
    //     s.set('preapp2_Previous_Meeting_Who', '');
    //     s.set('preapp2_PreviouslyApplied', 'Yes');
	//
    //     s.set('preapp2_Hear_About_Us_2_Other', 'x');
    //     s.set('preapp2_Previous_Meeting', 'No');
    //     s.set('preapp2_PreviouslyApplied', 'No');
	//
    // }

    // @isTest
    // public static void ApplicationForm_PreApp2_Controller_Test() {
	//
    //     Test.setCurrentPage(Page.ApplicationForm_Preapp2);
	//
    //     ApplicationForm_PreApp2_Controller controller = new ApplicationForm_PreApp2_Controller();
	//
    //     controller.initPage();
	//
    //     // everything invalid
    //     controller.isValid();
	//
    //     ApplicationForm_PreApp2_Controller_SessionSetup(controller.session);
    //     controller.loadFormDataFromSession();
    //     controller.isValid();
	//
    //     System.debug(controller.errorMessages);
    //     System.assertEquals(false, controller.showError);
	//
    //     controller.nextStep();
	//
    //     // code coverage
    //     controller.getUniitems();
    //     System.assertEquals(true, controller.getHearAboutUsOther_Display());
    // }

    // @isTest
    // public static void ApplicationForm_Step1_Controller_Test() {}   // this class was made redundant

    // public static void ApplicationForm_CreateRecords(Session s) {
    //     Opportunity a = new Opportunity(
    //         Name = 'Test',
    //         StageName = 'Application In Progress',
    //         CloseDate = System.today()
    //     );
    //     INSERT a;
    //     s.set('OpportunityId', a.Id);
	//
    //     Contact c = new Contact(
    //         FirstName = 'Test',
    //         LastName = 'Test'
    //     );
    //     INSERT c;
    //     s.set('ContactId', c.Id);
    // }

    // public static void ApplicationForm_Step2_Controller_SessionSetup(Session s) {
    //     Id test_university_id = [SELECT Id FROM Account WHERE Name = 'Test University' LIMIT 1][0].Id;
    //     s.set('step2_TE_NameOfQualification', '');
    //     s.set('step2_TE_Institution', 'x');
    //     s.set('step2_TE_EducationLevel', 'x');
    //     s.set('step2_TE_NameOfQualification', 'x');
    //     s.set('step2_TE_DegreeSpecialisation', 'x');
    //     s.set('step2_TE_AdditionalDegreeSpecialisation', 'x');
	//
    //     // Good files
    //     s.set('step2_TE_AttachmentName', 'x');
    //     s.set('step2_AS_AttachmentName', 'x');
    //     s.set('step2_More_AttachmentName', 'x');
	//
    //     // Good dates
    //     s.set('step2_TE_StartDate_Month', '2');
    //     s.set('step2_TE_StartDate_Year', '2000');
    //     s.set('step2_TE_EndDate_Month', '3');
    //     s.set('step2_TE_EndDate_Year', '2000');
	//
    //     s.set('step2_AS_StartDate_Month', '2');
    //     s.set('step2_AS_StartDate_Year', '2000');
    //     s.set('step2_AS_EndDate_Month', '3');
    //     s.set('step2_AS_EndDate_Year', '2000');
	//
    //     // Set an institution
    //     s.set('step2_TE_Institution', test_university_id);
    //     s.set('step2_AS_Institution', 'Other (please specify)');
    //     s.set('step2_TE_Institution', 'Other (please specify)');
    //     s.set('step2_AS_Institution_Other', 'Test');
    //     s.set('step2_TE_Institution_Other', 'Test');
    //     s.set('step2_TE_FileUploaded', 'asdas');
    //     s.set('step2_AS_FileUploaded', '');
    //     s.set('step2_More_FileUploaded', '');
    //     s.set('step2_AS_Institution', test_university_id);
	//
    //     s.set('step2_TE_EducationLevel', 'x');
    //     s.set('step2_TE_NameOfQualification', 'x');
    //     s.set('step2_TE_DegreeSpecialisation', 'x');
    //     s.set('step2_TE_AdditionalDegreeSpecialisation', 'x');
	//
    //     s.set('preapp2_Email', 'example@example.com');
    //     s.set('preapp2_First_Name', 'b');
    //     s.set('preapp2_Surname', 'b');
    //     s.set('OpportunityExternalId', 'pretendcontactid-2017');
	//
    //     s.set('step2_WAM', '0');
    // }

    // @isTest
    // public static void ApplicationForm_Step2_Controller_Test() {
	//
    //     Id test_university_id = [SELECT Id FROM Account WHERE Name = 'Test University' LIMIT 1][0].Id;
    //     Test.setCurrentPage(Page.ApplicationForm_Step2);
	//
    //     ApplicationForm_Step2_Controller controller = new ApplicationForm_Step2_Controller();
	//
    //     controller.initPage();
    //     ApplicationForm_CreateRecords(controller.session);
	//
    //     controller.isValid(); // everything is invalid
	//
    //     // special test cases
    //     Blob attachment_justright = Blob.valueOf('x'.repeat(controller.MAX_ATTACHMENT_SIZE));
    //     Blob attachment_toobig    = Blob.valueOf('x'.repeat(controller.MAX_ATTACHMENT_SIZE + 1));
	//
    //     controller.step2_AS_Institution = 'Other (please specify)';
    //     controller.isValid();
	//
    //     controller.step2_TE_EducationLevel            = '';
    //     controller.step2_TE_Institution_Other_Display = false;
    //     controller.step2_AS_Institution_Other_Display = false;
	//
    //     controller.step2_AS_Institution               = 'Other (please specify)';
    //     controller.step2_AS_Institution_Other         = '';
    //     controller.step2_AS_StartDate_Month           = '';
    //     controller.step2_AS_StartDate_Year            = '';
    //     controller.step2_AS_EndDate_Month             = '';
    //     controller.step2_AS_EndDate_Year              = '';
	//
    //     // Bad files
    //     controller.step2_TE_AttachmentName            = 'x';
    //     controller.step2_TE_AttachmentBody            = attachment_toobig;
    //     controller.step2_AS_AttachmentName            = 'x';
    //     controller.step2_AS_AttachmentBody            = attachment_toobig;
    //     controller.step2_More_AttachmentName          = 'x';
    //     controller.step2_More_AttachmentBody          = attachment_toobig;
	//
    //     // Bad dates
    //     controller.step2_TE_StartDate_Month           = '2';
    //     controller.step2_TE_StartDate_Year            = '2000';
    //     controller.step2_TE_EndDate_Month             = '1';
    //     controller.step2_TE_EndDate_Year              = '2000';
	//
    //     controller.step2_AS_Institution               = 'Test Institution'; // needed else the AS dates aren't tested
    //     controller.step2_AS_StartDate_Month           = '2';
    //     controller.step2_AS_StartDate_Year            = '2000';
    //     controller.step2_AS_EndDate_Month             = '1';
    //     controller.step2_AS_EndDate_Year              = '2000';
	//
    //     controller.isValid();
	//
    //     ApplicationForm_Step2_Controller_SessionSetup(controller.session);
    //     controller.loadFormDataFromSession();
    //     controller.step2_TE_AttachmentBody   = attachment_justright;
    //     controller.step2_AS_AttachmentBody   = attachment_justright;
    //     controller.step2_More_AttachmentBody = attachment_justright;
    //     controller.isValid();
	//
    //     // we NEED it to be valid for nextStep() to get proper code coverage
    //     System.debug(LoggingLevel.ERROR, 'ApplicationForm_Step2_Controller_Test errorMessages:');
    //     System.debug(LoggingLevel.ERROR, controller.errorMessages);
    //     System.assertEquals(false, controller.showError);
	//
    //     controller.nextStep();
	//
    //     // get some code coverage
    //     controller.getWAMSelectOptions();
    //     controller.continueStep();
	//
    // }

    // @isTest
    // public static void ApplicationForm_Step3_Controller_Test() { // LEGACY
    //     Test.setCurrentPage(Page.ApplicationForm_Step3);
	//
    //     // Insert Applicant Record
    //     Contact c = new Contact(FirstName = 'Roger', Lastname = 'Smith');
    //     c.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Applicants' AND SObjectType = 'Contact'][0].Id;
    //     INSERT c;
	//
    //     // Retrieve One2One Account
    //     Account a = [SELECT Id FROM Account WHERE npe01__One2OneContact__c = :c.Id];
	//
    //     // Insert Opportunity
    //     Opportunity o = new Opportunity(
    //         Name      = 'Test Application',
    //         AccountId = a.Id,
    //         CloseDate = Date.today(),
    //         StageName = 'Application Received'
    //     );
    //     INSERT o;
	//
    //     Session session = new Session();
    //     session.set('ContactId', c.Id);
    //     session.set('OpportunityId', o.Id);
    //     session.set('applicationform_preapp1_completed', 'true');
    //     session.set('applicationform_preapp2_completed', 'true');
    //     session.saveSession();
	//
    //     Test.startTest();
    //     // Appication Form - Step 3
    //     ApplicationForm_Step3_Controller controller = new ApplicationForm_Step3_Controller();
    //     controller.initPage();
    //     session.set('preapp1_PermanentResidency', 'asdasdas');
    //     session.set('applicationform_preapp1_completed', 'asdasd');
    //     session.saveSession();
    //     controller.initPage();
    //     session.set('applicationform_preapp2_completed', 'asdasd');
    //     session.saveSession();
    //     controller.initPage();
    //     session.set('step1Completed', 'asdasd');
    //     session.saveSession();
    //     controller.initPage();
    //     session.set('step2Completed', 'asdasd');
    //     session.saveSession();
    //     controller.initPage();
	//
	//
    //     controller.initPage();
    //     controller.previousStep();
    //     controller.saveForLater();
    //     controller.runValidation();
    //     controller.nextStep();
    //     controller.step3_SecondarySchool = '';
    //     controller.step3_YearCompleted = '';
    //     controller.step3_NameOfQualification = '';
    //     controller.step3_OverallScore = '';
    //     controller.step3_Subjects = '';
    //     controller.step3_SchoolCompletedInSuburb = '';
    //     controller.runValidation();
    //     controller.nextStep();
    //     controller.step3_SecondarySchool = 'x';
    //     controller.step3_YearCompleted = 'x';
    //     controller.step3_NameOfQualification = 'x';
    //     controller.step3_OverallScore = 'x';
    //     controller.step3_Subjects = 'x';
    //     controller.step3_SchoolCompletedInSuburb = 'x';
    //     controller.runValidation();
    //     controller.nextStep();
    //     controller.step3_SchoolInCapitalCity = null;
    //     controller.runValidation();
    //     controller.nextStep();
    //     controller.step3_SchoolCompletedInState = null;
    //     controller.runValidation();
    //     controller.nextStep();
    //     controller.step3_SchoolInCapitalCity = 'Yes';
    //     controller.step3_SchoolCompletedInState = 'Victoria';
    //     controller.nextStep();
    //     controller.runValidation();
    //     Test.stopTest();
    // }

    // public static void ApplicationForm_Step4_Controller_SessionSetup(Session s) {
    //     s.set('step5_StartDate1_Year', '2014');
    //     s.set('step5_EndDate1_Year', '2015');
	//
    //     s.set('step4_CV_AttachmentName', 'my_resume.txt');
	//
    //     s.set('step5_PositionOfResponsibility1', 'a');
    //     s.set('step5_PositionOutline1', 'a');
    //     s.set('step5_KeyAchievements1', 'a');
    //     s.set('step5_EvidenceOfSkills1', 'a');
    //     s.set('step5_MajorAchievements', 'a');
    //     s.set('step5_StartDate1_Month', '01');
    //     s.set('step5_StartDate1_Year', '2011');
    //     s.set('step5_EndDate1_Month', '01');
    //     s.set('step5_EndDate1_Year', '2012');
    //     s.set('step5_Organisation1', 'Test');
    //     s.set('step5_LeadershipCategory1', 'Test');
    //     s.set('step4_CV_AttachmentName', 'Test');
    //     s.set('step4_CV_FileUploaded', 'Test');
    //     s.set('step4_RefereeName1', 'Test');
    //     s.set('step4_RefereeEmail1', 'test@example.com');
    //     s.set('step4_RefereePhoneNumber1', '0400000000');
	//
    // }

    // @isTest
    // public static void ApplicationForm_Step4_Controller_Test() {
	//
    //     Test.setCurrentPage(Page.ApplicationForm_Step4);
	//
    //     ApplicationForm_Step4_Controller controller = new ApplicationForm_Step4_Controller();
	//
    //     controller.initPage();
    //     ApplicationForm_CreateRecords(controller.session);
	//
    //     // everything invalid
    //     controller.isValid();
	//
    //     controller.step5_StillCurrent1       = false;
    //     controller.step5_StartDate1_Month    = '01';
    //     controller.step5_StartDate1_Year     = '2015';
    //     controller.step5_EndDate1_Month      = '01';
    //     controller.step5_EndDate1_Year       = '2014';
    //     controller.step5_LeadershipCategory1 = 'Other';
	//
    //     controller.step4_CV_AttachmentName   = 'Test';
    //     controller.step4_CV_AttachmentBody   = Blob.valueOf('a');
	//
    //     controller.session.set('ContactExternalId', 'test');
    //     controller.session.set('OpportunityExternalId', 'test');
	//
    //     controller.isValid();
	//
	//
    //     ApplicationForm_Step4_Controller_SessionSetup(controller.session);
    //     controller.loadFormDataFromSession();
    //     controller.isValid();
	//
    //     // we NEED it to be valid for nextStep() to get proper code coverage
    //     System.debug(LoggingLevel.ERROR, 'ApplicationForm_Step4_Controller_Test errorMessages:');
    //     System.debug(LoggingLevel.ERROR, controller.errorMessages);
    //     System.assertEquals(false, controller.showError);
	//
    //     controller.nextStep();
	//
    //     // Code coverage
    //     controller.continueStep();
    // }

    // public static void ApplicationForm_Step5_Controller_SessionSetup(Session s) {
    //     s.set('step5_WhyDoYouWishToParticipate', 'a');
    //     s.set('step5_HowWillYouSupportTheMission', 'a');
    //     s.set('step5_HowWillYouContribute', 'a');
    // }

    // @isTest
    // public static void ApplicationForm_Step5_Controller_Test() {
	//
    //     Test.setCurrentPage(Page.ApplicationForm_Step5);
	//
    //     ApplicationForm_Step5_Controller controller = new ApplicationForm_Step5_Controller();
	//
    //     controller.initPage();
    //     ApplicationForm_CreateRecords(controller.session);
	//
    //     // Everything invalid
    //     controller.isValid();
	//
    //     ApplicationForm_Step5_Controller_SessionSetup(controller.session);
    //     controller.loadFormDataFromSession();
    //     controller.isValid();
	//
    //     // we NEED it to be valid for nextStep() to get proper code coverage
    //     System.debug(controller.errorMessages);
    //     System.assertEquals(false, controller.showError);
	//
    //     controller.nextStep();
    // }

    // public static void ApplicationForm_Step6_Controller_SessionSetup(Session s) {
    //     s.set('step6_Other_Language_1', 'x');
    //     s.set('step6_Other_Language_1_Proficiency', 'x');
    //     s.set('step6_Other_Language_2', 'x');
    //     s.set('step6_Other_Language_2_Proficiency', 'x');
	//
    //     s.set('ContactExternalId', 'test');
    //     s.set('OpportunityExternalId', 'test');
    // }

    // @isTest
    // public static void ApplicationForm_Step6_Controller_Test() {
	//
    //     Test.setCurrentPage(Page.ApplicationForm_Step6);
	//
    //     ApplicationForm_Step6_Controller controller = new ApplicationForm_Step6_Controller();
	//
    //     controller.initPage();
    //     ApplicationForm_CreateRecords(controller.session);
	//
    //     // everything invalid
    //     controller.isValid();
	//
    //     controller.step6_Heritage = new List<String> {'Chinese', 'Australian'};
	//
    //     controller.step6_Other_Language_1             = 'x';
    //     controller.step6_Other_Language_1_Proficiency = null;
    //     controller.step6_Other_Language_2             = 'x';
    //     controller.step6_Other_Language_2_Proficiency = null;
    //     controller.isValid();
	//
    //     controller.step6_Other_Language_1             = null;
    //     controller.step6_Other_Language_1_Proficiency = 'x';
    //     controller.step6_Other_Language_2             = null;
    //     controller.step6_Other_Language_2_Proficiency = 'x';
    //     controller.isValid();
	//
    //     ApplicationForm_Step6_Controller_SessionSetup(controller.session);
    //     controller.loadFormDataFromSession();
    //     controller.isValid();
	//
    //     // we NEED it to be valid for nextStep() to get proper code coverage
    //     System.debug(controller.errorMessages);
    //     System.assertEquals(false, controller.showError);
	//
    //     controller.nextStep();
    // }

    // @isTest
    // public static void ApplicationForm_Submit_Controller_Test() {
	//
    //     Test.setCurrentPage(Page.ApplicationForm_Submit);
	//
    //     // Appication Form - Submit
    //     ApplicationForm_Submit_Controller controller = new ApplicationForm_Submit_Controller();
	//
    //     // Init the page, verify is valid.
    //     controller.initPage();
    //     ApplicationForm_CreateRecords(controller.session);
	//
    //     ApplicationForm_PreApp1_Controller_SessionSetup(controller.session);
    //     ApplicationForm_PreApp2_Controller_SessionSetup(controller.session);
    //     ApplicationForm_Step2_Controller_SessionSetup(controller.session);
    //     ApplicationForm_Step4_Controller_SessionSetup(controller.session);
    //     ApplicationForm_Step5_Controller_SessionSetup(controller.session);
    //     ApplicationForm_Step6_Controller_SessionSetup(controller.session);
    //     controller.loadFormDataFromSession();
    //     controller.isValid();
	//
    //     System.debug(controller.errorMessages);
	//
    //     System.assertEquals(false, controller.ApplicationForm_PreApp1_ShowError);
    //     System.debug(LoggingLevel.ERROR, controller.ApplicationForm_PreApp1_ErrorMessages);
    //     System.assertEquals(false, controller.ApplicationForm_PreApp2_ShowError);
    //     System.debug(LoggingLevel.ERROR, controller.ApplicationForm_PreApp2_ErrorMessages);
    //     System.assertEquals(false, controller.ApplicationForm_Step2_ShowError);
    //     System.debug(LoggingLevel.ERROR, controller.ApplicationForm_Step2_ErrorMessages);
    //     System.assertEquals(false, controller.ApplicationForm_Step4_ShowError);
    //     System.debug(LoggingLevel.ERROR, controller.ApplicationForm_Step4_ErrorMessages);
    //     System.assertEquals(false, controller.ApplicationForm_Step5_ShowError);
    //     System.debug(LoggingLevel.ERROR, controller.ApplicationForm_Step5_ErrorMessages);
    //     System.assertEquals(false, controller.ApplicationForm_Step6_ShowError);
    //     System.debug(LoggingLevel.ERROR, controller.ApplicationForm_Step6_ErrorMessages);
	//
    //     System.assertEquals(false, controller.showError);
	//
    //     System.assertNotEquals(null, controller.step2_TE_FileUploaded);
    //     System.assertNotEquals(null, controller.step2_AS_FileUploaded);
    //     System.assertNotEquals(null, controller.step2_More_FileUploaded);
    //     System.assertNotEquals(null, controller.step4_CV_FileUploaded);
	//
    //     controller.nextStep();
	//
    //     // code coverage
    //     controller.downloadPDF();
	//
    //     System.assertEquals(null, controller.step2_TE_FileUploaded);
    //     System.assertEquals(null, controller.step2_AS_FileUploaded);
    //     System.assertEquals(null, controller.step2_More_FileUploaded);
    //     System.assertEquals(null, controller.step4_CV_FileUploaded);
	//
    // }

    // @isTest
    // public static void ApplicationForm_Complete_Controller_Test() {
    //     Test.setCurrentPage(Page.ApplicationForm_Complete);
	//
    //     Test.startTest();
    //     // Appication Form - Complete
    //     ApplicationForm_Complete_Controller controller_complete = new ApplicationForm_Complete_Controller();
    //     controller_complete.initPage();
    //     Test.stopTest();
    // }

    // @isTest
    // public static void ApplicationForm_Resume_Controller_Test() {
    //     PageReference pr = Page.ApplicationForm_Resume;
    //     Test.setCurrentPage(pr);
	//
    //     Test.startTest();
	//
    //     // Applicaton Form - Resume
    //     ApplicationForm_Resume_Controller controller_resume = new ApplicationForm_Resume_Controller();
    //     controller_resume.loadFormDataFromSession();
    //     controller_resume.saveFormDataToSession();
    //     controller_resume.setRelativePages();
    //     controller_resume.initPage();
    //     pr.getParameters().put('id', 'randomidstring');
    //     controller_resume.initPage();
	//
    //     Test.stopTest();
    // }

    // @isTest
    // public static void ApplicationForm_SaveForLater_Controller_Test() {
    //     Test.setCurrentPage(Page.ApplicationForm_SaveForLater);
	//
    //     Test.startTest();
	//
    //     ApplicationForm_SaveForLater_Controller controller = new ApplicationForm_SaveForLater_Controller();
    //     controller.initPage();
    //     controller.loadFormDataFromSession();
    //     controller.saveFormDataToSession();
    //     controller.setRelativePages();
    //     controller.backToApplication();
    //     controller.session.set('preapp2_email', 'test@test.com');
    //     controller.sendEmail();
	//
    //     Test.stopTest();
    // }

    /* END APPLICATIONFORM TESTS */



    @isTest
    public static void testChangePasswordController() {
        Test.startTest();
        // Instantiate a new controller with all parameters in the page
        ChangePasswordController controller = new ChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1';
        controller.verifyNewPassword = 'qwerty1';
        System.assertEquals(controller.changePassword(), null);
        Test.stopTest();
    }

    @isTest
    public static void testCounter() {
        Test.startTest();
        //first page view
        CookieController controller = new CookieController();
        System.assert(controller.getCount() == '1');

        //second page view
        controller = new CookieController();
        System.assert(controller.getCount() == '2');
        Test.stopTest();
    }

    @isTest
    public static void testForgotPasswordController() {
        Test.startTest();
        // Instantiate a new controller with all parameters in the page
        ForgotPasswordController controller = new ForgotPasswordController();
        controller.username = 'tfa@appichar.com.au.appichar';
        System.assertEquals(controller.forgotPassword(), null);
        Test.stopTest();
    }

    @isTest
    public static void Test_Method5() {
        Test.startTest();
        Portal_Controller pc = new Portal_Controller();
        pc.initPage();
        Test.stopTest();
    }

    @isTest
    public static void testSiteLoginController() {
        Test.startTest();
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController();
        controller.username = 'test@salesforce.com';
        controller.password = '123456';
        System.assertEquals(controller.login(), null);
        Test.stopTest();
    }

    @isTest
    public static void testRegistration() {
        Test.startTest();
        SiteRegisterController controller = new SiteRegisterController();
        controller.username = 'test@force.com';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);
        //controller.createPortalUser( username accountid password)
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);
        Test.stopTest();
    }

    @isTest
    public static void test2() {
        Test.startTest();
        TriggerValidation.setTriggerFired('testTrigger');
        TriggerValidation.hasTriggerFired('testTrigger');
        TriggerValidation.setTriggerFired('testTrigger');
        TriggerValidation.hasTriggerFired('testTrigger');
        TriggerValidation.removeTriggerFired('testTrigger');
        Test.stopTest();
    }


    @isTest
    public static void test() {

        Id contactRecordType = [SELECT Id FROM RecordType WHERE Name = 'Applicants' AND SObjectType = 'Contact'][0].Id;
        Id schoolRecordType = [SELECT Id FROM RecordType WHERE Name = 'School' AND SObjectType = 'Account'][0].Id;
        Id universityRecordType = [SELECT Id FROM RecordType WHERE Name = 'University' AND SObjectType = 'Account'][0].Id;

        Account uni = new Account(Name = 'Test Uni', Type = 'University', RecordTypeId = universityRecordType);
        INSERT uni;

        Contact contact = new Contact();
        contact.RecordTypeId = contactRecordType;
        contact.FirstName = 'asdasd';
        contact.LastName = 'asdasd';
        INSERT contact;

        // Account account = [SELECT Id FROM Account WHERE npe01__One2OneContact__c = :contact.Id][0];
		contact = [SELECT Id, AccountId FROM Contact WHERE Id = :contact.Id];

        System.debug('Do we have it'+contact);

        // Opportunity op = new Opportunity(Name = 'Test Application', CloseDate = Date.today(), AccountId = account.Id, preapp2_Current_institution__c = uni.Id, StageName = 'Placement - Tentative', Round__c = 'Test Round', step2_TE_DegreeSpecialisation__c = 'Degree Specialisation', step2_AS_AdditionalDegreeSpecialisation__c = 'Additional Specialisation', step2_TE_NameOfQualification__c = 'Test Analyst', step3_OverallScore__c = '95.5', preapp2_Surname__c = 'Surname');
        Opportunity op = new Opportunity(Name = 'Test Application', CloseDate = Date.today(), AccountId = contact.AccountId, preapp2_Current_institution__c = uni.Id, StageName = 'Placement - Tentative', Round__c = 'Test Round', step2_TE_DegreeSpecialisation__c = 'Degree Specialisation', step2_AS_AdditionalDegreeSpecialisation__c = 'Additional Specialisation', step2_TE_NameOfQualification__c = 'Test Analyst', step3_OverallScore__c = '95.5', preapp2_Surname__c = 'Surname');
        INSERT op;

        List<Contact> contacts = new List<Contact>();
        contacts.add(contact);

        Account school = new Account();
        school.RecordTypeId = schoolRecordType;
        school.Name = 'School 1';
        INSERT school;

        Vacancy__c vacancy = new Vacancy__c();
        vacancy.School__c = school.Id;
        INSERT vacancy;

        Placement__c placement = new Placement__c();
        placement.Associate__c = contact.Id;
        placement.Vacancy__c = vacancy.Id;
        INSERT placement;


        contact = [
            SELECT
                Id,
                School__c,
                University_Affiliation__c,
                Placement_status__c,
                Round__c,
                Field_of_study_1__c,
                Field_of_Study_2__c,
                Qualification__c,
                ENTER_Score__c,
                Cohort_Year__c,
                Engagement_Cycle__c,
                Level_of_Influence__c,
                Level_of_interest__c,
                Stakeholder_Type__c,
                Sector__c
            FROM Contact
            WHERE Id = :contact.Id
        ];


        Test.startTest();
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(contacts);
        ssc.setSelected(contacts);
        ConvertToAssociate cta = new ConvertToAssociate(ssc);
        Apexpages.currentPage().getParameters().put('retURL', '121331');
        //cta.convert();
        //cta.getMySelectedSize();
        Test.stopTest();

        /*System.assertEquals(contact.School__c, school.Id);
           System.assertEquals(contact.University_Affiliation__c, uni.Id);
           System.assertEquals(contact.Placement_status__c, op.StageName);
           System.assertEquals(contact.Round__c, op.Round__c);
           System.assertEquals(contact.Field_of_study_1__c, op.step2_TE_DegreeSpecialisation__c);
           System.assertEquals(contact.Field_of_Study_2__c, op.step2_AS_AdditionalDegreeSpecialisation__c);
           System.assertEquals(contact.Qualification__c, op.step2_TE_NameOfQualification__c);
           System.assertEquals(contact.ENTER_Score__c, Decimal.valueOf(op.step3_OverallScore__c));
           System.assertEquals(contact.Cohort_Year__c, String.valueOf(System.now().year() + 1));
           System.assertEquals(contact.Engagement_Cycle__c, 'Highly Engaged');
           System.assertEquals(contact.Level_of_Influence__c, 'Medium');
           System.assertEquals(contact.Level_of_interest__c, 'Positive');
           System.assertEquals(contact.Stakeholder_Type__c, 'Associate');
           System.assertEquals(contact.Sector__c, 'Associate');*/
    }

    // @isTest
    // public static void Test_Method() {
    //     // Insert Applicant Record
    //     Contact contact = new Contact();
    //     contact.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Applicants' AND SObjectType = 'Contact'][0].Id;
    //     contact.FirstName = 'Peter';
    //     contact.Lastname = 'Orange';
    //     INSERT contact;
	//
    //     // Retrieve One2One Account
    //     Account account = [SELECT Id FROM Account WHERE npe01__One2OneContact__c = :contact.Id];
    //     TriggerValidation.removeTriggerFired('CopyOpportunityStageToContact');
    //     Test.startTest();
    //     // Insert Opportunity
    //     Opportunity opportunity = new Opportunity();
    //     opportunity.Name = 'Test Application';
    //     opportunity.AccountId = account.Id;
    //     opportunity.CloseDate = Date.today();
    //     opportunity.StageName = 'Application Received';
    //     INSERT opportunity;
    //     TriggerValidation.removeTriggerFired('CopyOpportunityStageToContact');
    //     Available_Associates__c aa = new Available_Associates__c(Associate_Contact__c = contact.id);
    //     INSERT aa;
    //     // Update Application
    //     opportunity.StageName = 'Assessed - Waiting on 2nd Review';
    //     UPDATE opportunity;
    //     TriggerValidation.removeTriggerFired('CopyOpportunityStageToContact');
    //     opportunity.StageName = 'Placement - Tentative';
    //     UPDATE opportunity;
    //     TriggerValidation.removeTriggerFired('CopyOpportunityStageToContact');
    //     // Delete Application
    //     delete opportunity;
    //     Test.stopTest();
    // }

    @isTest
    public static void Test_Method2() {
        Id RecTypeId = [SELECT Id FROM RecordType WHERE Name = 'Applicants' AND SObjectType = 'Contact'][0].Id;
        Contact contact = new Contact();
        contact.RecordTypeId = RecTypeId;
        contact.FirstName = 'Dana';
        contact.Lastname = 'Ryan';
        INSERT contact;

        // Create Phone Session Configuration
        Phone_Session_Configuration__c psc = new Phone_Session_Configuration__c();
        psc.Sessions_Start_Date__c = Date.newInstance(2000, 1, 1);
        psc.Sessions_End_Date__c = Date.newInstance(2000, 1, 1);
        psc.Sessions_Start_Time__c = '9:00';
        psc.Sessions_End_Time__c = '12:00';
        psc.Interview_Length__c = '60';
        psc.Time_Between_Interviews__c = '10';
        psc.Lunch_Break__c = 'Yes';
        psc.Lunch_Break_Starts__c = '12:00';
        psc.Lunch_Break_Ends__c = '12:00';
        psc.Active__c = true;
        INSERT psc;

        List<Active_Session__c> asList = new List<Active_Session__c>();
        List<Inactive_Session__c> sessions = [SELECT Id, Day__c, Start_Date_Only__c, Start_Time_Only__c FROM Inactive_Session__c WHERE Active__c = true];
        Active_Session__c activeSession = new Active_Session__c();
        activeSession.Interviewer__c = UserInfo.getUserId();
        activeSession.Inactive_Session__c = sessions[0].Id;
        activeSession.Contact__c = contact.Id;
        asList.add(activeSession);
        Active_Session__c activeSession2 = new Active_Session__c();
        activeSession2.Interviewer__c = UserInfo.getUserId();
        activeSession2.Inactive_Session__c = sessions[0].Id;
        activeSession2.Contact__c = contact.Id;
        asList.add(activeSession2);
        INSERT asList;

        Test.startTest();
        Phone_Sessions_Add_Sessions_Controller psasc = new Phone_Sessions_Add_Sessions_Controller();
        psasc.initPage();
        psasc.Cancel();
        psasc.UpdateMySessions();
        psasc.tableRecords[0].Selected = !psasc.tableRecords[0].Selected;
        psasc.UpdateMySessions();
        Test.stopTest();
    }

    @isTest
    public static void Test_Method3() { // Create Phone Session Configuration
        Phone_Session_Configuration__c psc = new Phone_Session_Configuration__c();
        psc.Sessions_Start_Date__c = Date.newInstance(2001, 1, 1);
        psc.Sessions_End_Date__c = Date.newInstance(2001, 1, 1);
        psc.Sessions_Start_Time__c = '11:00';
        psc.Sessions_End_Time__c = '13:00';
        psc.Interview_Length__c = '60';
        psc.Time_Between_Interviews__c = '10';
        psc.Lunch_Break__c = 'Yes';
        psc.Lunch_Break_Starts__c = '12:00';
        psc.Lunch_Break_Ends__c = '12:30';
        psc.Active__c = true;
        INSERT psc;

        // Create Alternate Phone Session User
        User tfaUser = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1][0];

        // Create a new Contact Record
        Contact contact = new Contact();
        contact.FirstName = 'Daniel';
        contact.LastName = 'Green';
        contact.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Applicants' AND SObjectType = 'Contact' LIMIT 1][0].Id;
        INSERT contact;

        List<Inactive_Session__c> sessions = [SELECT Id, Day__c, Start_Date_Only__c, Start_Time_Only__c FROM Inactive_Session__c WHERE Active__c = true LIMIT 2];
        Active_Session__c activeSession = new Active_Session__c();
        activeSession.Interviewer__c = UserInfo.getUserId();
        activeSession.Inactive_Session__c = sessions[0].Id;
        activeSession.Contact__c = contact.Id;
        INSERT activeSession;

        activeSession = new Active_Session__c();
        activeSession.Interviewer__c = UserInfo.getUserId();
        //  activeSession.Inactive_Session__c = sessions[1].Id;
        //INSERT activeSession;

        Test.startTest();
        Phone_Sessions_Home_Controller pshc = new Phone_Sessions_Home_Controller();
        pshc.initPage();
        pshc.UPDATEView();
        pshc.AddSessions();
        pshc.userName = 'TFA User';
        pshc.UPDATEView();
        Test.stopTest();
    }

    @isTest
    public static void Test_Method4() { // Create Phone Session Configuration

        INSERT new Phone_Session_Configuration__c(
            Sessions_Start_Date__c     = System.today(),
            Sessions_End_Date__c       = System.today().addDays(2),
            Sessions_Start_Time__c     = '9:00',
            Sessions_End_Time__c       = '15:00',
            Interview_Length__c        = '60',
            Time_Between_Interviews__c = '5',
            Lunch_Break__c             = 'Yes',
            Lunch_Break_Starts__c      = '12:00',
            Lunch_Break_Ends__c        = '12:00',
            Active__c                  = true
        );

        // Create Phone Session Configuration - Test No Lunch Break
        INSERT new Phone_Session_Configuration__c(
            Sessions_Start_Date__c     = System.today(),
            Sessions_End_Date__c       = System.today().addDays(2),
            Sessions_Start_Time__c     = '08:00',
            Sessions_End_Time__c       = '11:00',
            Interview_Length__c        = '60',
            Time_Between_Interviews__c = '10',
            Lunch_Break__c             = 'No',
            Active__c                  = true
        );

        // Create a new TFA User
        User tfaUser = [SELECT Id FROM User WHERE isactive = TRUE LIMIT 1][0];

		Account acct = new Account(
			Name = 'Test',
			OwnerId = [SELECT Id FROM User WHERE IsActive = TRUE AND UserRoleId != NULL LIMIT 1].Id
		);
		INSERT acct;

        // Create a new Contact Record
        Contact c = new Contact(
            FirstName    = 'Portal',
            LastName     = 'User',
			AccountId    = acct.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Applicants' AND SObjectType = 'Contact' LIMIT 1][0].Id
        );
        INSERT c;

        Account defaultAccount = new Account(Name = Label.TFA_Default_Account);
        insert defaultAccount;
        
        // create an application for the User
        List<Application__c> applicationsList = new List<Application__c>();
        Application__c app = new Application__c(
                Contact__c = c.Id,
                Stage__c = 'VI - Invitation made',
                VI_Rebooked__c = false

        );

        applicationsList.add(app);
        insert applicationsList;


        // Create a new Portal User
        User portalUser = new User(
            FirstName         = 'Portal',
            LastName          = 'User',
            Alias             = 'portalUs',
            Email             = 'PortalUser@test.com',
            CommunityNickname = 'portaluser',
            Username          = 'portaluser@test.com',
            ProfileId         = [SELECT Id FROM Profile WHERE Name = 'TFA Community User' LIMIT 1][0].Id,
            EmailEncodingKey  = 'UTF-8',
            LocaleSidKey      = 'en_US',
            LanguageLocaleKey = 'en_US',
            TimeZoneSidKey    = 'Australia/Sydney',
            Phone_Sessions__c = false,
            ContactId         = c.Id
        );
        INSERT portalUser;

        List<Inactive_Session__c> sessions = [SELECT Id, Day__c, Start_Date_Only__c, Start_Time_Only__c FROM Inactive_Session__c WHERE Active__c = true];
        Active_Session__c activeSession    = new Active_Session__c();
        activeSession.Interviewer__c       = tfaUser.Id;
        activeSession.Inactive_Session__c  = sessions[0].Id;
        activeSession.Contact__c           = c.Id;
        INSERT activeSession;

        Datetime currentTime = System.now();
        Datetime futureTime = System.now().addHours(3);

        Test.startTest();
        System.RunAs(tfaUser) {
            PhoneSession_CutomerPortal_Controller thisClass = new PhoneSession_CutomerPortal_Controller();
            thisClass.initPage();
        }
        System.RunAs(portalUser) {
            PhoneSession_CutomerPortal_Controller thisClass = new PhoneSession_CutomerPortal_Controller();
            thisClass.initPage();
            thisClass.selectedDay = null;
            thisClass.dayChanged();
            thisClass.selectedDay = sessions[0].Day__c + ', ' + sessions[0].Start_Date_Only__c;
            thisClass.dayChanged();
            thisClass.selectedTime = sessions[0].Start_Time_Only__c;
            thisClass.submit();
            thisClass.initPage();
            thisClass.generateCalendarURL(currentTime, futureTime);
            thisClass.allowReschedule();
            thisClass.updateSDInterviewer(applicationsList, tfaUser.Id);
        }
        Test.stopTest();
    }

    @isTest
    public static void Test_Method6() { // Insert Applicant Record

		Account acct = new Account(
			Name = 'Test',
			OwnerId = [SELECT Id FROM User WHERE IsActive = TRUE AND UserRoleId != NULL LIMIT 1].Id
		);
		INSERT acct;


        Contact c = new Contact();
        c.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Applicants' AND SObjectType = 'Contact'][0].Id;
        c.FirstName = 'Barry';
        c.Lastname = 'Yawn';
        c.MailingState = 'VIC';
		c.AccountId = acct.Id;
        INSERT c;

        // Retrieve One2One Account
        // Account account1 = [SELECT Id FROM Account WHERE npe01__One2OneContact__c = :c.Id];

        // Insert Application
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Application';
        // opportunity.AccountId = account1.Id;
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'Selection Day - Invitation made';
        INSERT opportunity;

        // Insert Hosting Organisation Record
        Account account2 = new Account();

        List<RecordType> rtList = new List<RecordType>([SELECT Id FROM RecordType WHERE DeveloperName = 'Service_Provider' AND SObjectType = 'Account']);
        if (!rtList.isEmpty()) {
            account2.RecordTypeId = rtList[0].Id;
        }

        account2.Name = 'Test Account';
        account2.BillingState = 'VIC';
        INSERT account2;

        // Insert Selection Day Config Record
        Selection_Day_Config__c sdc = new Selection_Day_Config__c();
        sdc.Date__c = Date.today().addDays(2);
        sdc.Start_Time__c = '9:00';
        sdc.End_Time__c = '9:30';
        sdc.Capacity__c = 10;
        sdc.Hosting_Organisation__c = account2.id;

        INSERT sdc;

        // Create a new TFA User
        User tfaUser = [SELECT Id FROM User WHERE isactive = TRUE LIMIT 1][0];

        // Create a new Portal User
        User portalUser = new User();
        portalUser.FirstName = 'Portal';
        portalUser.LastName = 'User';
        portalUser.Alias = 'portalUs';
        portalUser.Email = 'PortalUser@test.com';
        portalUser.CommunityNickname = 'portaluser';
        portalUser.Username = 'portaluser@test.com';
        portalUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'TFA Community User' LIMIT 1][0].Id;
        portalUser.EmailEncodingKey = 'UTF-8';
        portalUser.LocaleSidKey = 'en_US';
        portalUser.LanguageLocaleKey = 'en_US';
        portalUser.TimeZoneSidKey = 'Australia/Sydney';
        portalUser.Phone_Sessions__c = false;
        portalUser.ContactId = c.Id;
        INSERT portalUser;

        Test.startTest();

        System.RunAs(tfaUser) {
            SelectionDay_CustomerPortal_Controller sdcpc = new SelectionDay_CustomerPortal_Controller();
            sdcpc.initPage();
        }

        System.RunAs(portalUser) {
            SelectionDay_CustomerPortal_Controller sdcpc = new SelectionDay_CustomerPortal_Controller();
            sdcpc.initPage();
            sdcpc.selectedSD = sdcpc.getSelectionDays()[1].getValue();
            sdcpc.getDefaultVic();

            for (String s : new List<String> {'Victoria', 'New South Wales', 'Western Australia', 'Queensland', 'Northern Territory', 'South Australia', 'Tasmania', 'Australian Capital Territory'}
                 ) {
                sdcpc.convertState(s);
            }

            sdcpc.submit();
        }


        // Insert Selection Day Attendee Record
        Selection_Day_Attendees__c sda = new Selection_Day_Attendees__c();
        sda.Selection_Day_Config__c = sdc.Id;
        sda.Contact__c = c.Id;
        sda.Enrollment_Status__c = 'Booked';
        INSERT sda;

        // Update Selection Day Attendee Record
        sda.Enrollment_Status__c = 'Withdrawn';
        UPDATE sda;

        // Update Selection Day Attendee Record
        sda.Enrollment_Status__c = 'Booked';
        UPDATE sda;

        // Delete Selection Day Attendee Record
        delete sda;
        Test.stopTest();
    }

    @isTest
    public static void myTest() {
        Date futureDate = System.today().addYears(50);
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType = 'Campaign' and isActive = true];
        Map<String, String> campRT = new Map<String, String> {};
        for (RecordType rt: rtypes) {
            campRT.put(rt.Name, rt.Id);
        }
        //create objects
        Account account = new Account(name = 'test Account', npe01__SYSTEMIsIndividual__c = true);
        INSERT account;

        Contact cont2 = new Contact(FirstName = 'Velikovski', LastName = 'Velikovski');
        INSERT cont2;

        TriggerValidation.removeTriggerFired('CopyOpportunityStageToContact');
        Opportunity opp = new Opportunity(name = 'test', AccountId = account.id, CloseDate = futuredate, StageName = 'Application Received');
        INSERT opp;

        Contact cont = new Contact(FirstName = 'AnotherTestLastname', LastName = 'AnotherTestLastname', AccountId = account.id);
        INSERT cont;

        Test.startTest();
        OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId = opp.id, ContactId = cont.id);
        INSERT ocr;

        TriggerValidation.removeTriggerFired('CopyOpportunityStageToContact');
        UPDATE opp;

        Campaign camp = new Campaign(name = 'testCampaign', RecordTypeId = campRT.get('Event'));
        INSERT camp;

        Campaign camp2 = new Campaign(name = 'testCampaign2', RecordTypeId = campRT.get('Direct Mail'));
        INSERT camp2;

        Lead lead = new Lead(LastName = 'test', Company = 'test', Status = 'Open - Not Contacted');
        INSERT lead;

        Task task = new Task(Subject = 'Meeting', WhoId = lead.id);
        INSERT task;

        delete task;
        Test.stopTest();
    }

    @isTest
    public static void invite_to_phone_session() {
        Date futureDate = System.today().addYears(50);
        Id recordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Application' AND SObjectType = 'Opportunity'][0].Id;

        Contact cont2 = new Contact(LastName = 'differentLastName', FirstName = 'Boris', Email = 'differentb.bachovski@appichar.com.au');
        INSERT cont2;

        Account account = new Account(name = 'test Account', npe01__SYSTEMIsIndividual__c = true, npe01__One2OneContact__c = cont2.Id);
        INSERT account;

        Test.startTest();

        TriggerValidation.removeTriggerFired('CopyOpportunityStageToContact');
        Opportunity opp = new Opportunity(RecordTypeId = recordTypeId, name = 'test', AccountId = account.id, CloseDate = futuredate, StageName = 'Assessed - Invite to Phone Screen', Stage_Communication__c = 'Invite to Phone Screen', Phone_Screen_Invite_Sent__c = false);
        INSERT opp;

        TriggerValidation.removeTriggerFired('CopyOpportunityStageToContact');
        UPDATE opp;

        List<Contact> contacts = new List<Contact>();
        Contact c = new Contact(FirstName = 'AnotherBacho', LastName = 'AnotherBacho', Placement_status__c = 'Placed');
        INSERT c;

        c.Placement_status__c = 'Tentative';
        c.AccountId = account.Id;
        UPDATE c;

        c.Placement_status__c = 'Withdrawn';
        c.Applicant_Withdrawn_Reason__c = 'asdasdas';
        c.Withdrawn_Date__c = Date.today();
        UPDATE c;

        c.Placement_status__c = 'Placed';
        UPDATE c;

        Test.stopTest();
    }

    // @isTest
    // public static void PhoneSessionBooked() {
    //     Date futureDate = System.today().addYears(50);
    //     Id recordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Application' AND SObjectType = 'Opportunity'][0].Id;
	//
    //     Contact c = new Contact(LastName = 'testLastname', FirstName = 'Boris', Email = 'b.bachovski@appichar.com.au');
    //     INSERT c;
	//
    //     Account a = new Account(name = 'test Account', npe01__SYSTEMIsIndividual__c = true, npe01__One2OneContact__c = c.Id);
    //     INSERT a;
	//
    //     Opportunity o = new Opportunity(RecordTypeId = recordTypeId, Name = 'test', AccountId = a.id, CloseDate = futuredate, StageName = 'Assessed - Invite to Phone Screen', Stage_Communication__c = 'Invite to Phone Screen', Phone_Screen_Invite_Sent__c = false);
    //     INSERT o;
	//
    //     Contact c2 = new Contact(LastName = 'ASdasd', FirstName = 'cont2asd');
    //     INSERT c2;
	//
    //     Phone_Session_Configuration__c psc = new Phone_Session_Configuration__c(
    //         Sessions_Start_Time__c         = '9:00',
    //         Sessions_Start_Date__c         = Date.newInstance(2001, 1, 1),
    //         Sessions_End_Time__c           = '13:00',
    //         Sessions_End_Date__c           = Date.newInstance(2001, 1, 1),
    //         Interview_Length__c            = '60',
    //         Time_Between_Interviews__c     = '0',
    //         Lunch_Break__c                 = 'Yes',
    //         Lunch_Break_Starts__c          = '12:00',
    //         Lunch_Break_Ends__c            = '13:00',
    //         Active__c                      = true
    //     );
    //     INSERT psc;
	//
    //     Inactive_Session__c is = new Inactive_Session__c(
    //         Name                           = 'Asd',
    //         Phone_Session_Configuration__c = psc.Id,
    //         Start_Time__c                  = DateTime.newInstance(2011, 01, 01, 7, 0, 0),
    //         End_Time__c                    = DateTime.newInstance(2011, 01, 01, 18, 0, 0)
    //     );
    //     INSERT is;
	//
    //     Active_Session__c aps = new Active_Session__c(
    //         Contact__c          = c2.Id,
    //         Interviewer__c      = UserInfo.getUserId(),
    //         Inactive_Session__c = is.Id
    //     );
	//
    //     INSERT aps;
    //     aps.Contact__c = c.Id;
    //     UPDATE aps;
	//
    //     UPDATE is;
	//
    // }

    @isTest
    public static void Sync() {
        Phone_Session_Configuration__c psc = new Phone_Session_Configuration__c(
            Sessions_Start_Time__c         = '9:00',
            Sessions_Start_Date__c         = Date.newInstance(2001, 1, 1),
            Sessions_End_Time__c           = '13:00',
            Sessions_End_Date__c           = Date.newInstance(2001, 1, 1),
            Interview_Length__c            = '60',
            Time_Between_Interviews__c     = '0',
            Lunch_Break__c                 = 'Yes',
            Lunch_Break_Starts__c          = '12:00',
            Lunch_Break_Ends__c            = '13:00',
            Active__c                      = true
        );
        INSERT psc;

        Test.startTest();

        Inactive_Session__c isc = new Inactive_Session__c(
            Name                           = 'Asd',
            Phone_Session_Configuration__c = psc.Id,
            Start_Time__c                  = DateTime.newInstance(2011, 01, 01, 7, 0, 0),
            End_Time__c                    = DateTime.newInstance(2011, 01, 01, 18, 0, 0)
        );
        INSERT isc;
        // UPDATE psc;
        Test.stopTest();
    }
}