/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 12-08-2024
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
                task.whoId = req.conId; // Link to the Contact's ID 
                task.Subject = req.subject;
                task.Description = req.plainTextBody; // Email body text as task description
                task.Status = 'Completed'; // Set status as per requirement
                task.Priority = 'Normal'; // Set priority if required
                task.ActivityDate = Date.today(); // Set task date
                task.Type__c = 'SMS';
                task.WhatId = (req.relatedToId != null) ? req.relatedToId : null;
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
        return [SELECT Id, Address, DisplayName, IsAllowAllProfiles FROM OrgWideEmailAddress WHERE IsAllowAllProfiles = true];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<npe5__Affiliation__c> getEmailIds(List<String> affiliationIds){
        List<npe5__Affiliation__c> emailList = new List<npe5__Affiliation__c>();
        Set<String> setaffiliationIds = new Set<String>();
        
        if(!affiliationIds.isEmpty()){
            emailList = [SELECT id, Email__c, npe5__Contact__c FROM npe5__Affiliation__c WHERE Id IN :affiliationIds];
            return emailList;
        }
        return null;
    }
    
    public static Map<Id, String> getEmailCollectionMap(List<String> affiliationIds){
        Map<Id, String> result = new Map<Id, String>();
        for(npe5__Affiliation__c affiliation : [SELECT id, Email__c, npe5__Contact__c FROM npe5__Affiliation__c WHERE Id IN :affiliationIds]){
            result.put(affiliation.Id, affiliation.Email__c);
        }
        // Map<String,String> emailIDsMap = new Map<String,String>();
        // List<npe5__Affiliation__c> affiliationRecordList = new List<npe5__Affiliation__c>();
        // affiliationRecordList  = getEmailIds(affiliationIds);
        // if(affiliationRecordList!=null && !affiliationRecordList.isEmpty()){
        //     for(npe5__Affiliation__c affRecord : affiliationRecordList){
        //         if(!emailIDsMap.containsKey(affRecord.Email__c))  {
        //             emailIDsMap.put(affRecord.Email__c,affRecord.npe5__Contact__c);
        //         }
        //     }
        // }
        return result;
    }
    @AuraEnabled
    public static void sentMail(String fromEmailId, List<String> toEmailList, String subject, String htmlBody, String fileName, String base64Data, String fileType, List<String> affiliationIds, Boolean isSms){
        list<Task> taskList = new list<Task>();
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
       // List<EmailMessage> emailAcctivityList= new List<EmailMessage> ();
        Map<Id, String> emailIDsMap =  new Map<Id, String>(); //getEmailCollectionMap(affiliationIds);
        Map<Id, npe5__Affiliation__c> affiliationsMap = new Map<Id, npe5__Affiliation__c>(); 
        system.debug('@@emailIDsMap ' +emailIDsMap);
        List<String> burstSMSemails = new List <String>();
        OrgWideEmailAddress orgWideSms = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = 'apply@teachforaustralia.org' LIMIT 1];
        
        for(npe5__Affiliation__c affiliation : [SELECT Id, Burst_SMS_Email__c, Email__c, npe5__Contact__c FROM npe5__Affiliation__c WHERE Id IN :affiliationIds]){
            affiliationsMap.put(affiliation.Id, affiliation);
            burstSMSemails.add(affiliation.Burst_SMS_Email__c);
        }

        Map<Id, String> bodyWithMergeField = mergeFields(htmlBody, affiliationIds);
        System.debug(toEmailList);
        System.debug(isSms);
        if(!affiliationsMap.isEmpty()){
            for(String affId : affiliationIds){
                Messaging.SingleEmailMessage emailObj = new Messaging.SingleEmailMessage();
                String contactId = '';
                // if(!emailIDsMap.isEmpty() && emailIDsMap.containsKey(affId)){
                //     contactId = emailIDsMap.get(affId);
                // }
            System.debug(fromEmailId);
                if(!String.isBlank(fromEmailId) && !isSms){
                    System.debug('Im here');
                    emailObj.setOrgWideEmailAddressId((isSms) ? orgWideSms.Id :fromEmailId);
                }

                if(isSms){
                    System.debug('Im here');
                    emailObj.setOrgWideEmailAddressId(orgWideSms.Id);
                }

                System.debug(orgWideSms.Id);
                
                emailObj.setToAddresses(new List<String>{(isSms) ? affiliationsMap.get(affId).Burst_SMS_Email__c : affiliationsMap.get(affId).Email__c});
                emailObj.setSubject((isSms) ? 'SMS:' + 'Sent by ' + UserInfo.getFirstName()  : subject);
                emailObj.setHtmlBody(bodyWithMergeField.get(affId));
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
                // if(!String.isBlank(contactId)){
                //     emailObj.setTargetObjectId(contactId);
                // }
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
                //if (!String.isBlank(contactId)) {
                    Task task = new Task();
                    task.WhoId = affiliationsMap.get(affId).npe5__Contact__c; // Link to the Contact's ID
                    task.Subject = (isSms) ? 'SMS:' + 'Sent by ' + UserInfo.getFirstName()  : subject;
                    task.Description = htmlBody; // Email body text as task description
                    task.Status = 'Completed'; // Set status as required
                    task.Priority = 'Normal'; // Set priority if required
                    task.ActivityDate = Date.today(); // Set the date to today's date
    
                    taskList.add(task);
                //}
            }
          
            Messaging.sendEMail(msgList);
            if(!taskList.isEmpty()){
                insert taskList;
            }
            

        }
        
        // if(!emailIDsMap.isEmpty()){
        //     for (String email : toEmailList) {
            
        //         Messaging.SingleEmailMessage emailObj = new Messaging.SingleEmailMessage();
        //         String contactId = '';
        //         if(!emailIDsMap.isEmpty() && emailIDsMap.containsKey(email)){
        //             contactId = emailIDsMap.get(email);
        //         }
        //         if(!String.isBlank(fromEmailId)){
        //             emailObj.setOrgWideEmailAddressId(fromEmailId);
        //         }
                
        //         emailObj.setToAddresses((isSms) ? burstSMSemails : toEmailList);
        //         emailObj.setSubject((isSms) ? 'SMS:' + subject : subject);
        //         emailObj.setHtmlBody(bodyWithMergeField.get(contactId));
        //         if(!String.isBlank(fileName)){
        //             Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        //             attachment.setFileName(fileName);
        //             attachment.setBody(EncodingUtil.base64Decode(base64Data));
        //             attachment.setContentType(fileType);
        //             emailObj.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
        //         }
        //         if(!affiliationIds.isEmpty()){
        //             emailObj.setSaveAsActivity(true);
        //         }
        //         // if(!String.isBlank(contactId)){
        //         //     emailObj.setTargetObjectId(contactId);
        //         // }
        //         msgList.add(emailObj);

        //        /* if(!String.isBlank(contactId)){
        //         EmailMessage emailMsg = new EmailMessage();
        //         emailMsg.relatedToId  = contactId; // Set to the Contact's ID
        //         emailMsg.Subject = subject;
        //         emailMsg.TextBody = htmlBody;
        //         emailMsg.ToAddress = email;
        //         emailMsg.FromAddress = fromEmailId; // Use your company's email address here
        //         emailMsg.Status = '3'; // Set status to 'Sent'
        //         emailMsg.Incoming = false; // Outgoing email
        //         emailMsg.MessageDate = System.now();
        //         emailAcctivityList.add(emailMsg);
        //     } */

        //         // Create Task record to track this email for each contact
        //         if (!String.isBlank(contactId)) {
        //             Task task = new Task();
        //             task.WhoId = contactId; // Link to the Contact's ID
        //             task.Subject = subject;
        //             task.Description = htmlBody; // Email body text as task description
        //             task.Status = 'Completed'; // Set status as required
        //             task.Priority = 'Normal'; // Set priority if required
        //             task.ActivityDate = Date.today(); // Set the date to today's date
    
        //             taskList.add(task);
        //         }
        //     }
          
        //     Messaging.sendEMail(msgList);
        //     if(!taskList.isEmpty()){
        //         insert taskList;
        //     }
        // }
        
    }

    private static Map<Id, String> mergeFields(String body, List<String> recordIds){
        Map<Id, String> returnResult = new Map<Id, String>();
        List<npe5__Affiliation__c> affiliations = [SELECT Id, npe5__Contact__c, npe5__Contact__r.FirstName, npe5__Contact__r.lastName, npe5__Contact__r.Preferred_Name__c, Application_Link__c FROM npe5__Affiliation__c WHERE Id IN :recordIds];
        
        //replace the merge field every contact
        for(npe5__Affiliation__c aff : affiliations){
            String tempBody = body;
            //now let's replace the merge field tags to real values
            tempBody = tempBody.replace('{!Contact.FirstName}', (aff.npe5__Contact__r.FirstName != null) ? aff.npe5__Contact__r.FirstName : '');
            tempBody = tempBody.replace('{!Contact.LastName}', (aff.npe5__Contact__r.LastName != null) ? aff.npe5__Contact__r.LastName : '');
            tempBody = tempBody.replace('{!Contact.PreferredName}', (aff.npe5__Contact__r.Preferred_Name__c != null) ? aff.npe5__Contact__r.Preferred_Name__c : '');
            tempBody = tempBody.replace('{!Account.Applicant_Form_URL__c}', (aff.Application_Link__c != null) ? aff.Application_Link__c : '');
            returnResult.put(aff.Id, tempBody);
        }

        return returnResult;
    }

    @AuraEnabled
    public static void sentCampaignMail(String fromEmailId,String campaignId, String emailType, String subject, String htmlBody, String fileName, String base64Data, String fileType, String contactId, Boolean isSms){
        list<Task> taskList = new list<Task>();
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        String email = '';
        OrgWideEmailAddress orgWideSms = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = 'apply@teachforaustralia.org' LIMIT 1];
        
        List<CampaignMember> campaignMembers =  [SELECT contact.FirstName,contact.lastName,contact.Preferred_Name__c,contact.Application_Link__c,Contact.npe01__HomeEmail__c,Contact.npe01__WorkEmail__c,Contact.Burst_SMS_Email__c  FROM CampaignMember Where CampaignId =:campaignId];

        if(!campaignMembers.isEmpty()){
            for(CampaignMember member :campaignMembers){
                    String recipientEmailID = (emailType=='HOME' && member.Contact.npe01__HomeEmail__c != null)?member.Contact.npe01__HomeEmail__c:(emailType=='WORK' && member.Contact.npe01__WorkEmail__c != null)?member.Contact.npe01__WorkEmail__c:'';
                    if(!String.isBlank(recipientEmailID)){

                        Messaging.SingleEmailMessage emailObj = new Messaging.SingleEmailMessage();
                        if(!String.isBlank(fromEmailId) && !isSms){
                            emailObj.setOrgWideEmailAddressId((isSms) ? orgWideSms.Id :fromEmailId);
                        }

                        if(isSms){
                            emailObj.setOrgWideEmailAddressId(orgWideSms.Id);
                        }                
                        emailObj.setToAddresses(new List<String>{(isSms) ? member.Contact.Burst_SMS_Email__c :recipientEmailID});
                        emailObj.setSubject((isSms) ? 'SMS:' + subject : subject);
                        emailObj.setHtmlBody(mergeCampaignFields(htmlBody,member.Contact));
                        if(!String.isBlank(fileName)){
                            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                            attachment.setFileName(fileName);
                            attachment.setBody(EncodingUtil.base64Decode(base64Data));
                            attachment.setContentType(fileType);
                            emailObj.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
                        }
                        msgList.add(emailObj);
                
                        Task task = new Task();
                        task.WhoId = contactId; // Link to the Contact's ID
                        task.Subject = subject;
                        task.Description = mergeCampaignFields(htmlBody,member.Contact); // Email body text as task description
                        task.Status = 'Completed'; // Set status as required
                        task.Priority = 'Normal'; // Set priority if required
                        task.ActivityDate = Date.today(); // Set the date to today's date
                        taskList.add(task);
                
                    }
                }


                    Messaging.sendEMail(msgList);
                    if(!taskList.isEmpty()){
                        insert taskList;
                    }
            }                  
    }

    @AuraEnabled(cacheable=true)
    public static AggregateResult getCampaignAssociateEmailCount(String campaignId){
        return [SELECT count(Contact.npe01__HomeEmail__c),count(Contact.npe01__WorkEmail__c)  FROM CampaignMember Where CampaignId =:campaignId];
    }
    
    private static String mergeCampaignFields(String body, Contact contactObj){
            String tempBody = body;
            tempBody = tempBody.replace('{!Contact.FirstName}', (contactObj.FirstName != null) ? contactObj.FirstName : '');
            tempBody = tempBody.replace('{!Contact.LastName}', (contactObj.LastName != null) ? contactObj.LastName : '');
            tempBody = tempBody.replace('{!Contact.PreferredName}', (contactObj.Preferred_Name__c != null) ? contactObj.Preferred_Name__c : '');
            tempBody = tempBody.replace('{!Account.Applicant_Form_URL__c}', (contactObj.Application_Link__c != null) ? contactObj.Application_Link__c : '');
        return tempBody;
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