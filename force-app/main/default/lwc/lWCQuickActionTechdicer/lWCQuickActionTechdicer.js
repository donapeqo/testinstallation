import { LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class LWCQuickActionTechdicer extends LightningElement {
    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}