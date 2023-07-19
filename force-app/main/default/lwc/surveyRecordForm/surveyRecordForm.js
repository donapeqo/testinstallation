import { LightningElement, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';


import SURVEY_OBJECT from '@salesforce/schema/Survey__c';
import SURVEY_NAME_FIELD from '@salesforce/schema/Survey__c.Name__c';
import SURVEY_RATING_FIELD from '@salesforce/schema/Survey__c.Rating__c';


export default class surveyRecordForm extends LightningElement {
    @api recordId;
    objectApiName = SURVEY_OBJECT;
    surveyNameField = SURVEY_NAME_FIELD;
    surveyRatingField = SURVEY_RATING_FIELD;

   handleSuccess(event){
    const evt = new ShowToastEvent({
        title: 'Survey Created',
        message: 'Record ID: ' + event.detail.id,
        variant: 'success',

    });
    
    this.dispatchEvent(evt);

   }


   
}