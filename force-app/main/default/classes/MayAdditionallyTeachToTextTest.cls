@isTest
public class MayAdditionallyTeachToTextTest {
 
    @isTest
    static void testTriggerWithNonNullValues() {
        // Create a test Associate_Record__c object with non-null May_Additionally_Teach__c field
        Contact contact = new Contact();
        Application__c app = new Application__c();
        Application_Round__c cohort = new Application_Round__c();
        Associate_Record__c record = new Associate_Record__c(
            May_Additionally_Teach__c = 'Accounting;Drama;Biology',
            Contact__c = contact.id,
            Application_ID__c = app.id,
            Cohort_lookup__c = cohort.id
        );
        // Insert the test record
        insert record;
 
        // Retrieve the inserted record to verify the trigger execution
        Associate_Record__c insertedRecord = [SELECT Id, May_Additionally_Teach_Text__c FROM Associate_Record__c WHERE Id = :record.Id];
 
        // Verify the May_Additionally_Teach_Text__c contains the expected concatenated values
        System.assertEquals('Accounting\nBiology\nDrama', insertedRecord.May_Additionally_Teach_Text__c);
    }
 
    @isTest
    static void testTriggerWithNullAndEmptyValues() {
        // Create a test Associate_Record__c object with null and empty values in May_Additionally_Teach__c field
        Contact contact = new Contact();
        Application__c app = new Application__c();
        Application_Round__c cohort = new Application_Round__c();
        Associate_Record__c record = new Associate_Record__c(
            May_Additionally_Teach__c = 'Accounting;;Drama; ;Biology',
            Contact__c = contact.id,
            Application_ID__c = app.id,
            Cohort_lookup__c = cohort.id
        );
        // Insert the test record
        insert record;
 
        // Retrieve the inserted record to verify the trigger execution
        Associate_Record__c insertedRecord = [SELECT Id, May_Additionally_Teach_Text__c FROM Associate_Record__c WHERE Id = :record.Id];
 
        // Verify the May_Additionally_Teach_Text__c contains the expected concatenated values without null and empty values
        System.assertEquals('Accounting\nBiology\nDrama', insertedRecord.May_Additionally_Teach_Text__c);
    }
 
    @isTest
    static void testTriggerWithEmptyQualifiedToTeach() {
        // Create a test Associate_Record__c object with an empty May_Additionally_Teach__c field
        Contact contact = new Contact();
        Application__c app = new Application__c();
        Application_Round__c cohort = new Application_Round__c();
        Associate_Record__c record = new Associate_Record__c(
            May_Additionally_Teach__c = '',
            Contact__c = contact.id,
            Application_ID__c = app.id,
            Cohort_lookup__c = cohort.id
        );
        // Insert the test record
        insert record;
 
        // Retrieve the inserted record to verify the trigger execution
        Associate_Record__c insertedRecord = [SELECT Id, May_Additionally_Teach_Text__c FROM Associate_Record__c WHERE Id = :record.Id];
 
        // Verify the May_Additionally_Teach_Text__c is null or empty as there are no values to concatenate
        System.assertEquals(null, insertedRecord.May_Additionally_Teach_Text__c);
    }
 
    @isTest
    static void testTriggerWithNullQualifiedToTeach() {
        // Create a test Associate_Record__c object with a null May_Additionally_Teach__c field
        Contact contact = new Contact();
        Application__c app = new Application__c();
        Application_Round__c cohort = new Application_Round__c();
        Associate_Record__c record = new Associate_Record__c(
            May_Additionally_Teach__c = null,
            Contact__c = contact.id,
            Application_ID__c = app.id,
            Cohort_lookup__c = cohort.id
        );
        // Insert the test record
        insert record;
 
        // Retrieve the inserted record to verify the trigger execution
        Associate_Record__c insertedRecord = [SELECT Id, May_Additionally_Teach_Text__c FROM Associate_Record__c WHERE Id = :record.Id];
 
        // Verify the May_Additionally_Teach_Text__c is null or empty as there are no values to concatenate
        System.assertEquals(null, insertedRecord.May_Additionally_Teach_Text__c);
    }
 
    @isTest
    static void testTriggerWithUpdate() {
        // Create a test Associate_Record__c object with initial values
        Contact contact = new Contact();
        Application__c app = new Application__c();
        Application_Round__c cohort = new Application_Round__c();
        Associate_Record__c record = new Associate_Record__c(
            May_Additionally_Teach__c = ' ;Biology',
            Contact__c = contact.id,
            Application_ID__c = app.id,
            Cohort_lookup__c = cohort.id
        );
        // Insert the test record
        insert record;
 
        // Update the test record with new values
        record.May_Additionally_Teach__c = 'Accounting;Drama;Biology';
        update record;
 
        // Retrieve the updated record to verify the trigger execution
        Associate_Record__c updatedRecord = [SELECT Id, May_Additionally_Teach_Text__c FROM Associate_Record__c WHERE Id = :record.Id];
 
        // Verify the May_Additionally_Teach_Text__c contains the expected concatenated values
        System.assertEquals('Accounting\nBiology\nDrama', updatedRecord.May_Additionally_Teach_Text__c);
    }
}