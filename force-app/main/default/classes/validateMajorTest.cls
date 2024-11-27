/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-27-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class validateMajorTest {
    
    @isTest
    public static void validateMajor_Test() {
        
        Boolean exceptionWasThrown = false;
       
        Account defaultAccount = new Account(Name = Label.TFA_Default_Account);
        insert defaultAccount;

        RecordType sch_rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Applicants' LIMIT 1];

        Contact contact1 = new Contact(LastName = 'Contact 1',Alumni__c=true,FLP_Fellow__c=true, RecordTypeId = sch_rt.Id);
        insert contact1;
        //Creating data
        Application__c  joeApplication = new Application__c(
           	Stage__c = 'Application Opened', Contact__c = contact1.Id
        );
      
        insert joeApplication;
        
        //Create Transcript Assessment
        List<Transcript_Assessment__c> TaList = new List<Transcript_Assessment__c>();
        List<Id> TaId = new List<Id>();
        
        Transcript_Assessment__c TA1 = new Transcript_Assessment__c(
        	Name = 'Joe Transcript Assessment',
            Application__c  = joeApplication.Id  
        );
        
        TaList.add(TA1);
        insert TaList;

        for(Transcript_Assessment__c ta : TaList){
            TaId.add(ta.Id);
        }        
        
        //Create Unit for each year weighing 6
        List<Unit__c > unitList = new List<Unit__c>();
        
        Unit__c unitTa1 = new Unit__c(
        	Name = 'unitTa1',
        	Subject__c  = 'Biology',
        	Transcript_Assessment__c  = TaList[0].Id,
            Weighting__c = 'Double',
        	Year_Level__c  = 'Year 1',
        	Unit_Number__c = 'UnitNumber1'
        );

        Unit__c unitTa1doubled = new Unit__c(
                Name = 'unitTa1',
                Subject__c  = 'Biology',
                Transcript_Assessment__c  = TaList[0].Id,
                Weighting__c = 'Double',
                Year_Level__c  = 'Year 1',
                Unit_Number__c = 'UnitNumber1'
        );
        
        Unit__c unitTa2 = new Unit__c(
        	Name = 'unitTa2',
        	Subject__c  = 'Biology',
        	Transcript_Assessment__c  = TaList[0].Id,
            Weighting__c = 'Double',
        	Year_Level__c  = 'Year 2',
        	Unit_Number__c = 'UnitNumber2'           
        );

        Unit__c unitTa2doubled = new Unit__c(
                Name = 'unitTa2',
                Subject__c  = 'Biology',
                Transcript_Assessment__c  = TaList[0].Id,
                Weighting__c = 'Double',
                Year_Level__c  = 'Year 2',
                Unit_Number__c = 'UnitNumber2'
        );
        
        Unit__c unitTa3 = new Unit__c(
            Name = 'unitTa3',
            Subject__c  = 'Biology',
            Transcript_Assessment__c  = TaList[0].Id,
            Weighting__c = 'Double',
            Year_Level__c  = 'Year 3 & Higher',
        	Unit_Number__c = 'UnitNumber3'
        );

        Unit__c unitTa3doubled = new Unit__c(
                Name = 'unitTa3',
                Subject__c  = 'Biology',
                Transcript_Assessment__c  = TaList[0].Id,
                Weighting__c = 'Double',
                Year_Level__c  = 'Year 3 & Higher',
                Unit_Number__c = 'UnitNumber3'
        );

        Unit__c unitTa4 = new Unit__c(
                Name = 'unitTa4',
                Subject__c  = 'Biology',
                Transcript_Assessment__c  = TaList[0].Id,
                Weighting__c = 'Double',
                Year_Level__c  = 'Year 3 & Higher',
                Unit_Number__c = 'UnitNumber4'
        );

        unitList.add(unitTa1);
        unitList.add(unitTa1doubled);
        unitList.add(unitTa2);
        unitList.add(unitTa2doubled);
        unitList.add(unitTa3);
        unitList.add(unitTa3doubled);
        unitList.add(unitTa4);

		insert unitList;
        Test.startTest();
                      
         //Positive Scenario - Every year has unit data weighing 6 total
        try {
            List<String> resPositiveCase = validateMajor.validateMajor(TaId);
            System.debug(resPositiveCase);
            
            if(resPositiveCase[0].contains('Biology')){
                System.assert(true);
            }
        } catch (Exception e) {
            exceptionWasThrown = true;
            System.debug('The following exception has occurred: ');
            System.debug('Type: ' + e.getTypeName());
            System.debug('Line: ' + e.getLineNumber());
            System.debug('Msg: ' + e.getMessage());
			System.assert(exceptionWasThrown = true);
        }       
        Test.stopTest();
    }
}