/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public without sharing class SendEmailController {


    //This is an invocable apex method to send email
    @InvocableMethod(label='Send SMS Email' description='Sends an email from Flow')
    public static void sendEmail(List<EmailRequest> requests) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        List<EmailMessage> emailMessages = new List<EmailMessage>();
        List<Task> tasks = new List<Task>();
        OrgWideEmailAddress orgWideEmail = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = 'apply@teachforaustralia.org' LIMIT 1];

        for (EmailRequest req : requests) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject(req.subject);
            // Set recipients
            email.setToAddresses(new List<String>{req.toAddress});
            //email.setHtmlBody(req.htmlBody);
            email.setHtmlBody(req.plainTextBody);
            //set from email address show be apply@teachforasutralia.org
            email.setOrgWideEmailAddressId(orgWideEmail.Id);
           /* if(!String.isBlank(req.conId)){
                email.setTargetObjectId(req.conId);
            }*/
            // Add email to the list to send
            //email.setTargetObjectId(req.conId);
            emails.add(email);


            if (!String.isBlank(req.conId)) {
                Task task = new Task();
                task.WhatId = req.conId; // Link to the Contact's ID 
                task.Subject = req.subject;
                task.Description = req.plainTextBody; // Email body text as task description
                task.Status = 'Completed'; // Set status as per requirement
                task.Priority = 'Normal'; // Set priority if required
                task.ActivityDate = Date.today(); // Set task date
        
                tasks.add(task);
            }

            // Create EmailMessage record for the timeline  Commenting for sometime for some solution
           /* EmailMessage emailMsg = new EmailMessage();
            emailMsg.ParentId = req.conId; // Set to the Contact's ID
            emailMsg.Subject = req.subject;
            //emailMsg.HtmlBody = req.htmlBody;
            emailMsg.TextBody = req.plainTextBody;
            emailMsg.ToAddress = req.toAddress;
            emailMsg.FromAddress = orgWideEmail.Address; // Use your company's email address here
            emailMsg.Status = '3'; // Set status to 'Sent'
            emailMsg.Incoming = false; // Outgoing email
            emailMsg.MessageDate = System.now();

            emailMessages.add(emailMsg);*/
        }
        
        // Send emails
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }

        // Insert tasks
        if (!tasks.isEmpty()) {
            insert tasks;
        }

        // Insert EmailMessage records to show on timeline
   /* if (!emailMessages.isEmpty()) {
        insert emailMessages;
    }*/
    }
    
    @AuraEnabled
    public static List<OrgWideEmailAddress> getOrgWideEmailIds(){
        return [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<npe5__Affiliation__c> getEmailIds(List<String> affiliationIds){
        List<npe5__Affiliation__c> emailList = new List<npe5__Affiliation__c>();
        Set<String> setaffiliationIds = new Set<String>();
        
        if(!affiliationIds.isEmpty()){
            emailList = [Select id, Email__c,npe5__Contact__c from npe5__Affiliation__c where id in: affiliationIds];
            return emailList;
        }
        return null;
    }
    
    public static Map<String,String> getEmailCollectionMap(List<String> affiliationIds ){
        Map<String,String> emailIDsMap = new Map<String,String>();
        List<npe5__Affiliation__c> affiliationRecordList = new List<npe5__Affiliation__c>();
        affiliationRecordList  = getEmailIds(affiliationIds);
        if(affiliationRecordList!=null && !affiliationRecordList.isEmpty()){
            for(npe5__Affiliation__c affRecord : affiliationRecordList){
                if(!emailIDsMap.containsKey(affRecord.Email__c))  {
                    emailIDsMap.put(affRecord.Email__c,affRecord.npe5__Contact__c);
                }
            }
        }
        return emailIDsMap;
    }
    @AuraEnabled
    public static void sentMail(String fromEmailId, List<String> toEmailList, String subject, String htmlBody, String fileName, String base64Data, String fileType, List<String> affiliationIds, Boolean isSms){
        list<Task> taskList = new list<Task>();
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
       // List<EmailMessage> emailAcctivityList= new List<EmailMessage> ();
        Map<String,String> emailIDsMap =  getEmailCollectionMap(affiliationIds);
        system.debug('@@emailIDsMap ' +emailIDsMap);
        List<String> burstSMSemails = new List <String>();
        for(npe5__Affiliation__c affiliation : [SELECT Id, Burst_SMS_Email__c FROM npe5__Affiliation__c WHERE Id IN :affiliationIds]){
            burstSMSemails.add(affiliation.Burst_SMS_Email__c);
        }

        if(!emailIDsMap.isEmpty()){
            for (String email : toEmailList) {
            
                Messaging.SingleEmailMessage emailObj = new Messaging.SingleEmailMessage();
                String contactId = '';
                if(!emailIDsMap.isEmpty() && emailIDsMap.containsKey(email)){
                    contactId = emailIDsMap.get(email);
                }
                if(!String.isBlank(fromEmailId)){
                    emailObj.setOrgWideEmailAddressId(fromEmailId);
                }
                
                emailObj.setToAddresses((isSms) ? burstSMSemails : toEmailList);
                emailObj.setSubject((isSms) ? 'SMS:' + subject : subject);
                emailObj.setHtmlBody(htmlBody);
                if(!String.isBlank(fileName)){
                    Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                    attachment.setFileName(fileName);
                    attachment.setBody(EncodingUtil.base64Decode(base64Data));
                    attachment.setContentType(fileType);
                    emailObj.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
                }
                if(!affiliationIds.isEmpty()){
                    emailObj.setSaveAsActivity(true);
                }
                if(!String.isBlank(contactId)){
                    emailObj.setTargetObjectId(contactId);
                }
                msgList.add(emailObj);

               /* if(!String.isBlank(contactId)){
                EmailMessage emailMsg = new EmailMessage();
                emailMsg.relatedToId  = contactId; // Set to the Contact's ID
                emailMsg.Subject = subject;
                emailMsg.TextBody = htmlBody;
                emailMsg.ToAddress = email;
                emailMsg.FromAddress = fromEmailId; // Use your company's email address here
                emailMsg.Status = '3'; // Set status to 'Sent'
                emailMsg.Incoming = false; // Outgoing email
                emailMsg.MessageDate = System.now();
                emailAcctivityList.add(emailMsg);
            } */

                // Create Task record to track this email for each contact
                if (!String.isBlank(contactId)) {
                    Task task = new Task();
                    task.WhatId = contactId; // Link to the Contact's ID
                    task.Subject = subject;
                    task.Description = htmlBody; // Email body text as task description
                    task.Status = 'Completed'; // Set status as required
                    task.Priority = 'Normal'; // Set priority if required
                    task.ActivityDate = Date.today(); // Set the date to today's date
    
                    taskList.add(task);
                }
            }
          /*  Messaging.sendEMail(msgList);
            if(!emailAcctivityList.isEmpty()){
                insert emailAcctivityList;
            }*/
        }
        
    }

    //merge field replace method
    private static String mergeFields(String body, Id recordId) {
        //Contact contact = [SELECT FirstName, LastName, Email, Account.Name FROM Contact WHERE Id = :recordId LIMIT 1];

        npe5__Affiliation__c aff = [SELECT Id, npe5__Contact__r.FirstName, npe5__Contact__r.lastName, npe5__Contact__r.Preferred_Name__c, Application_Link__c FROM npe5__Affiliation__c WHERE Id = :recordId];
        
        // Replace the merge fields with actual values
        body = body.replace('{!Contact.FirstName}', aff.npe5__Contact__r.FirstName);
        body = body.replace('{!Contact.LastName}', aff.npe5__Contact__r.LastName);
        body = body.replace('{!Contact.PreferredName}', aff.npe5__Contact__r.Preferred_Name__c);
        body = body.replace('{!Account.Applicant_Form_URL__c}', aff.Application_Link__c);

        return body;
    }
    
    public class EmailRequest {
        @InvocableVariable(label='To Address' description='Recipient email address' required=true)
        public String toAddress;
        
        @InvocableVariable(label='Subject' description='Email subject' required=true)
        public String subject;
        
        @InvocableVariable(label='Plain Text Body' description='Plain text email body' required=true)
        public String plainTextBody;

        @InvocableVariable(label='Contact Id' description='Contact Target Id' required=true)
        public Id conId;

        @InvocableVariable(label='Related To Id' description='Related to Id' required=false)
        public Id relatedToId;
    }
    
}