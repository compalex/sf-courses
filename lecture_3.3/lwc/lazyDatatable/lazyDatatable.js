import { LightningElement, api } from 'lwc';

import NotEnoughSeats from '@salesforce/label/c.NotEnoughSeats';
import NoSuitableTourists from '@salesforce/label/c.NoSuitableTourists';

import NAME_FIELD from '@salesforce/schema/Tourist__c.Name';
import EMAIL_FIELD from '@salesforce/schema/Tourist__c.Email__c';
import GENDER_FIELD from '@salesforce/schema/Tourist__c.Gender__c';

import getSuitableTourists from '@salesforce/apex/TripController.getSuitableTourists';

import { showToast } from 'c/utility';

const COLUMNS = [
    { 
        label: 'Tourist Name', 
        fieldName: 'nameUrl', 
        type: 'url', 
        typeAttributes: {label: { fieldName: NAME_FIELD.fieldApiName }, target: '_blank'}
    },
    { 
        label: 'Email', 
        fieldName: EMAIL_FIELD.fieldApiName, 
        type: 'email' 
    },
    { 
        label: 'Gender', 
        fieldName: GENDER_FIELD.fieldApiName, 
        type: 'text' 
    }
];

export default class LazyDatatable extends LightningElement {
    @api tripId;

    label = {
        NotEnoughSeats,
        NoSuitableTourists
    };
    tourists = [];
    columns = COLUMNS;
    rowLimit = 5;
    rowOffSet = 0;

    loadData() {
        return getSuitableTourists({tripId: this.tripId, limitSize: this.rowLimit, offset: this.rowOffSet})
        .then(result => {
            let nameUrl;
            result = result.map(row => { 
                nameUrl = `/${row.Id}`;
                return {...row , nameUrl} 
            })
            this.tourists = [...this.tourists, ...result];
        })
        .catch(error => {
            showToast(this, 'Error!', error.message, 'error');
        });
    }

    handleButtonClicked(event) {
        let selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
        const buttonClickedEvent = new CustomEvent(
            'clicked', 
            { detail: selectedRows });  
        this.dispatchEvent(cardClickedEvent);
    }

    connectedCallback() {
        this.loadData();
    }

    loadMoreData(event) {
        const { target } = event;
        target.isLoading = true;

        this.rowOffSet = this.rowOffSet + this.rowLimit;

        this.loadData()
        .then(() => {
            target.isLoading = false;
        });  
    }

    @api
    get selectedRows() {
        return this.template.querySelector('lightning-datatable').getSelectedRows();
    }
}