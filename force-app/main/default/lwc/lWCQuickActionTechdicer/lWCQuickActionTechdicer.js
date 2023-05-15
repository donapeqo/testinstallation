import { LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import generateData from './generateData';

const columns = [
    { label: 'Label', fieldName: 'name' },
    { label: 'Website', fieldName: 'website', type: 'url' },
    { label: 'Phone', fieldName: 'phone', type: 'phone' },
    { label: 'Balance', fieldName: 'amount', type: 'currency' },
    { label: 'CloseAt', fieldName: 'closeAt', type: 'date' },
];


export default class LWCQuickActionTechdicer extends LightningElement {
    data = [];
    columns = columns;
    rowOffset = 0;

    myVal = '<strong>Hello!</strong>';

    handleChange(event) {
        this.myVal = event.target.value;
    }


    connectedCallback() {
        this.data = generateData({ amountOfRecords: 100 });
    }
    
    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}