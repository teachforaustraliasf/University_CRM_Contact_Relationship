import { LightningElement,api,wire, track } from 'lwc';
import getCampaignAssociateEmailCount  from '@salesforce/apex/SendEmailController.getCampaignAssociateEmailCount';
import sentCampaignMail from '@salesforce/apex/SendEmailController.sentCampaignMail';
import getOrgWideEmailIds from '@salesforce/apex/SendEmailController.getOrgWideEmailIds';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import userEmailFIELD from '@salesforce/schema/User.Email';
import userFNameFIELD from '@salesforce/schema/User.FirstName';
import userLNameFIELD from '@salesforce/schema/User.LastName';

const smsMaxLimit = 600;
const emailMaxLimit = 5000;
const homeEmail = 'HOME';
const workEmail = 'WORK';

export default class SendCampaignEmail extends LightningElement {
    @api recordId;
    newEmail;
    @track items =[];
    senderEmailId ;
    senderEmailLabel;
    emailIdList = [];
    error;
    htmlBody;
    htmlBodyLength =0;
    emailSubject;
    userId = Id;
    @track emailOrgWideOptions = [];
    @track uploadedFiles = [];
    fileContent;
    fileName;
    fileType;
    showModal = false;
    currentUserFirstName;
    currentUserLastName;
    currentUserEmail;
    showSpinner = false;
    isSmsToggleOn = false;
    homeEmail;
    workEmail;
    RecipientEmail = homeEmail;
    campaignEmaild ;
    campaignContactId;
    homeEmailCount =0;
    workEmailCount =0;
    
    // Predefined merge fields
    mergeFields = [
        { label: 'First Name', value: '{!Contact.FirstName}' },
        { label: 'Last Name', value: '{!Contact.LastName}' },
        { label: 'Preferred Name', value: '{!Contact.PreferredName}' },
        { label: 'Application Form Link', value: '{!Account.Applicant_Form_URL__c}' }
    ];

    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    handleToggleChange(event) {
        this.isSmsToggleOn = event.target.checked;
    }
    get isAttachmentInvisible() {
        return this.isSmsToggleOn ? false : true;
    }
    get limitText(){
        return !this.isSmsToggleOn ? '/5000 send limits remaining' : '/600 send limits remaining';
    }
    @wire(getRecord, { recordId: Id, fields: [userFNameFIELD,userLNameFIELD, userEmailFIELD ]}) 
    currentUserInfo({error, data}) {
        if (data) {
            this.currentUserEmail = data.fields.Email.value;
            this.currentUserFirstName = data.fields.FirstName.value;
            this.currentUserLastName = data.fields.LastName.value;
            this.getOrgWideEmailList();
        } else if (error) {
            this.error = error ;
        }
    } 

    @wire(getCampaignAssociateEmailCount, { campaignId:'$recordId'}) 
    wireGetCampaignAssociateEmailCount({error, data}) {
        if (data) {
            this.homeEmailCount = data.expr0;
            this.workEmailCount = data.expr1;
           console.log('homeEmailCount ', this.homeEmailCount);
           console.log('workEmailCount ',this.workEmailCount);

        } else if (error) {
            this.error = error ;
            console.log('@getCampaignAssociateEmailCount error ',this.error);
        }
    }
    setCampaignAssociateEmailCount(campaignMembers){
       this.homeEmailCount = campaignMembers.expr0;
       this.workEmailCount = campaignMembers.expr1;

    }

    handleMergeFieldInsert(event) {
        const mergeField = event.target.value;
        this.htmlBody += mergeField; // Append the selected merge field to the body
    }

    getOrgWideEmailList(){
        getOrgWideEmailIds()
            .then(result => {
                this.emailOrgWideOptions = [];
                result.forEach(emailobj => {
                    this.emailOrgWideOptions.push({ label: emailobj.DisplayName.trim() +' <' + emailobj.Address.trim() +'>', value: emailobj.Id });
                });
                this.emailOrgWideOptions.push({ label: this.currentUserFirstName +' ' + this.currentUserLastName+ ' <'+ this.currentUserEmail +'>', value:'' });
                this.senderEmailId = '';
            })
            .catch(error => {
                this.error = error;
                console.log('@Error in getOrgWideEmailList ', error)
            });
    }

   setCampaignEmailId(){
        if(this.RecipientEmail == homeEmail){
            this.emailIdList.push(this.homeEmail) ;
        }else{
            this.emailIdList.push(this.workEmail) ;
        }
        console.log('@campaignEmaild ',  this.emailIdList);
   }
 
    handleChange(event){
        this.htmlBody = event.target.value;
        this.htmlBodyLength = this.htmlBody.length;
    }
 
    get upperLimit(){
        return (this.isSmsToggleOn?smsMaxLimit: emailMaxLimit)-this.htmlBodyLength;
    }

    handleEmailChange(event){
        this.newEmail = event.target.value;
    }

    handleKeyCheck(event){
        if (event.which == 13){
            let _item= {
                type: 'avatar',
                label: this.newEmail,
                fallbackIconName: 'standard:user',
                variant: 'circle',
                alternativeText: 'User avatar',
                isLink: true,
            }
            this.items.push(_item);
            this.template.querySelector('lightning-input[data-id="inputEmailID"]').value ='';
        }    
    }

    removePillItem(event) {
        const pillIndex = event.detail.index ? event.detail.index : event.detail.name;
        const itempill = this.items;
        itempill.splice(pillIndex, 1);       
        this.items = [...itempill];
    }

    handleSenderEmailChange(event){
        this.senderEmailId = event.target.value;
    }

    handleSendEmail(event){
        this.showSpinner = true;
        if(this.validate()){
            sentCampaignMail({ fromEmailId : this.senderEmailId.trim(),
                        campaignId : this.recordId,
                        emailType : this.RecipientEmail,
                        subject : this.emailSubject,
                        htmlBody : this.htmlBody,
                        fileName : this.fileName,
                        base64Data : this.fileContent,
                        fileType : this.fileType,
                        contactId : this.campaignContactId,
                        isSms : this.isSmsToggleOn})
            .then(result => {
                this.showSpinner = false;
                 console.log('@Email Sent Successfully!')
                 this.handleClose();
            })
            .catch(error => {
                this.error = error;
                this.accounts = undefined;
                console.log('@Email Error! ',error)
                this.showSpinner = false;
            })
            this.showModal = false;
        }else{
            this.showSpinner = false;
            this.showModal = true;
        }
        
    }

    handleSubjectChange(event){
        this.emailSubject = event.target.value;
    }

    validate(){
        let isValid = false;
        if(( (this.emailSubject != undefined && this.emailSubject != '') && (this.htmlBody != undefined && this.htmlBody != '') )){
            isValid = true;
        }
        return isValid;
    }
    get displayErrorMessage(){
        return (this.RecipientEmail == homeEmail && this.homeEmailCount==0)?'There is no Home Email in the associated contact against this campaign':(this.RecipientEmail == workEmail && this.workEmailCount==0)?'There is no Work Email in the associated contact against this campaign':'To send this email, add  a subject and body content.'
    }
    handleOpenFileUploader(event){
        this.template.querySelector('input[type="file"]').click();
    }

    handleFilesChange(event) {
        const uploadedFiles = event.target.files;
        this.uploadedFiles =  Array.from(event.target.files);
        const file = uploadedFiles[0];
        this.fileName = file.name;
        this.fileType = file.type;

        const reader = new FileReader();
        reader.onload = () => {
            this.fileContent = reader.result.split(',')[1];  
        };
        reader.readAsDataURL(file);
    }

    handleCloseModal(event){
        this.showModal = false;
    }
  
    handleClose() {
        const valueChangeEvent = new CustomEvent("valuechange", {
        detail: { }
        });
        this.dispatchEvent(valueChangeEvent);
    }
    get RecipientOptions(){
        return [
            { label: 'Home Email', value:homeEmail },
            { label: 'Work Email', value: workEmail },
        ];
    }
    handleRecipientEmailChange(event){
        this.RecipientEmail = event.target.value;
        this.setCampaignEmailId();
    }
}