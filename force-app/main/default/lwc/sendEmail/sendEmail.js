import { LightningElement,api,wire, track } from 'lwc';
import getEmailIds from '@salesforce/apex/SendEmailController.getEmailIds';
import sentMail from '@salesforce/apex/SendEmailController.sentMail';
import getOrgWideEmailIds from '@salesforce/apex/SendEmailController.getOrgWideEmailIds';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import userEmailFIELD from '@salesforce/schema/User.Email';
import userFNameFIELD from '@salesforce/schema/User.FirstName';
import userLNameFIELD from '@salesforce/schema/User.LastName';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';

export default class SendEmail extends NavigationMixin(LightningElement)  {
    @api ids;
    limitText = '/5000 send limits remaining';
    upperLimit = '5000';
    newEmail;
    @track items =[];
    senderEmailId ;
    senderEmailLabel;
    emailIdList = [];
    error;
    htmlBody;
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

    connectedCallback() {
        if (this.ids) {
            this.ids = this.ids.replace(/[\s]/g, '');
            this.ids = this.ids.split(',').filter(function (e) {
                return e != null && e != '';
            });
        }
        this.setRecipientValue();
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
    @wire(getEmailIds,{affiliationIds:'$ids'})
    wiredGetEmailIds({error,data}) {
        if (data) {
            data.forEach(emailobj => {
                if(emailobj.Email__c!==undefined){
                    this.emailIdList.push(emailobj.Email__c.trim());
                }
            });
        } else if (error) {
            this.error = error;
            console.log('@@this.error',this.error)
        }
    }


    setRecipientValue(){
        if(this.ids===undefined){
            return false;
        }
        let recipientCount= this.ids.length;
        let recipientLabel =recipientCount>1?recipientCount +' ' + 'recipient(s)':recipientCount +' ' + 'recipient'
        let _item= {
            type: 'avatar',
            label:recipientLabel ,
            fallbackIconName: 'standard:user',
            variant: 'circle',
            alternativeText: 'User avatar',
            isLink: true,
        }
        this.items.push(_item);
    }

    handleChange(event){
        this.htmlBody = event.target.value;
        this.setCharacterCount(this.htmlBody.length);
    }
 
   setCharacterCount(currentCharLength){
        this.upperLimit  = 5000-currentCharLength;
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
        if(this.validate()){
            this.showSpinner = true;
            sentMail({ fromEmailId : this.senderEmailId.trim(),
                        toEmailList : this.emailIdList,
                        subject : this.emailSubject,
                        htmlBody : this.htmlBody,
                        fileName : this.fileName,
                        base64Data : this.fileContent,
                        fileType : this.fileType,
                        affiliationIds : this.ids,
                        isSms : this.isSmsToggleOn})
            .then(result => {
                 console.log('@Email Sent Successfully!')
                 this.handleBack();
            })
            .catch(error => {
                this.error = error;
                this.accounts = undefined;
                console.log('@Email Error! ',error)
            })
            this.showModal = false;
            this.showSpinner = false;
        }else{
            this.showModal = true;
        }
        
    }

    handleSubjectChange(event){
        this.emailSubject = event.target.value;
    }

    validate(){
        let isValid = false;
        if(( (this.emailSubject != undefined && this.emailSubject != '') && (this.htmlBody != undefined && this.htmlBody != '') && (this.items !=undefined && this.items.length>0))){
            isValid = true;
        }
        return isValid;
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
  
    handleCancel(event){
        this.handleBack();
    }

    handleBack() {
        window.history.back();
    }
   
}