import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

import NotEnoughSeats from '@salesforce/label/c.NotEnoughSeats';
import NoTouristsSelected from '@salesforce/label/c.NoTouristsSelected';
import TripAssignmentTitle from '@salesforce/label/c.TripAssignmentTitle';
import TripAssignConfirmMsg from '@salesforce/label/c.TripAssignConfirmMsg';
import TouristsAssigned from '@salesforce/label/c.TouristsAssigned';

import AVAILABLE_SEATS_FIELD from '@salesforce/schema/Trip__c.Available_seats__c';
import NAME_FIELD from '@salesforce/schema/Tourist__c.Name';
import EMAIL_FIELD from '@salesforce/schema/Tourist__c.Email__c';
import GENDER_FIELD from '@salesforce/schema/Tourist__c.Gender__c';

import getSuitableTourists from '@salesforce/apex/TripController.getSuitableTourists';
import insertFlights from '@salesforce/apex/TripController.insertFlights';

import {getErrorShowToastEvent, getSuccessShowToastEvent} from 'c/utility';

const COLUMNS = [
    { label: 'Tourist Name', fieldName: NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Email', fieldName: EMAIL_FIELD.fieldApiName, type: 'email' },
    { label: 'Gender', fieldName: GENDER_FIELD.fieldApiName, type: 'text' }
];

export default class TouristRegistrator extends LightningElement {
    @api recordId;

    isLoading = false;
    columns = COLUMNS;

    @wire(getSuitableTourists, {tripId: '$recordId'}) 
    tourists;

    @wire(getRecord, {recordId: '$recordId', fields: [AVAILABLE_SEATS_FIELD]})
    trip;

    label = {
        NotEnoughSeats,
        NoTouristsSelected,
        TripAssignmentTitle,
        TripAssignConfirmMsg,
        TouristsAssigned
    };

    handleBtnClick(event) {
        let rowsNum = this.template.querySelector('lightning-datatable').getSelectedRows().length;

        if(!rowsNum) {
            this.dispatchEvent(getErrorShowToastEvent(this.label.NoTouristsSelected));
        } else if(this.trip.data.fields.Available_seats__c.value >= rowsNum) {
            this.showConfirmationWindow();
        } else {
            this.dispatchEvent(getErrorShowToastEvent(this.label.NotEnoughSeats));
        }
    }

    handleSubmitted() {
        this.isLoading = true;
        let selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
        let touristsToAssign = [];

        selectedRows.forEach(tourist => { 
            touristsToAssign.push(tourist.Id);
        });     

        insertFlights({touristIds: touristsToAssign, tripId: this.recordId})
        .then(result => {       
            refreshApex(this.tourists);
            this.isLoading = false;
            this.dispatchEvent(getSuccessShowToastEvent(this.label.TouristsAssigned));
        })
        .catch(error=> {
            this.isLoading = false;
            this.dispatchEvent(getErrorShowToastEvent(error.message));
        });
    }

    showConfirmationWindow() {
        const modal = this.template.querySelector("c-confirmation-window");
        modal.openModalBox();
    }

    get hasAvailableSeats() {
        return (this.trip.data.fields.Available_seats__c.value > 0);
    }

    get isDisabled() {
        return !(this.hasAvailableSeats);
    }
}