import { LightningElement, api, wire } from 'lwc';
import { createRecord, getRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NotEnoughSeats from '@salesforce/label/c.NotEnoughSeats';
import TouristsAssigned from '@salesforce/label/c.TouristsAssigned';
import AVAILABLE_SEATS_FIELD from '@salesforce/schema/Trip__c.Available_seats__c';
import NAME_FIELD from '@salesforce/schema/Tourist__c.Name';
import EMAIL_FIELD from '@salesforce/schema/Tourist__c.Email__c';
import GENDER_FIELD from '@salesforce/schema/Tourist__c.Gender__c';
import getSuitableTourists from '@salesforce/apex/TripController.getSuitableTourists';

const COLUMNS = [
    { label: 'Tourist Name', fieldName: NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Email', fieldName: EMAIL_FIELD.fieldApiName, type: 'email' },
    { label: 'Gender', fieldName: GENDER_FIELD.fieldApiName, type: 'text' }
];

export default class TouristRegistrator extends LightningElement {
    @api recordId;
    columns = COLUMNS;
    @wire(getSuitableTourists, {tripId: '$recordId'})
    tourists;
    @wire(getRecord, {recordId: '$recordId', fields: [AVAILABLE_SEATS_FIELD]})
    trip;

    get hasAvailableSeats() {
        return (this.trip.data.fields.Available_seats__c.value > 0);
    }

    label = {
        NotEnoughSeats,
        TouristsAssigned
    };

    handleBtnClick(event) {
        var rowsNum = this.template.querySelector('lightning-datatable').getSelectedRows().length;

        if(this.trip.data.fields.Available_seats__c.value >= rowsNum) {
            this.showConfirmationWindow();
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!',
                    message: this.label.NotEnoughSeats,
                    variant: 'error'
                })
            );
        }
    }

    handleSubmitted() {
        var selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
        
        selectedRows.forEach(tourist => {
            this.createFlight(tourist.Id);
        });

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success!',
                message: this.label.TouristsAssigned,
                variant: 'success'
            })
        );
    }

    showConfirmationWindow() {
        const modal = this.template.querySelector("c-confirmation-window");
        modal.openModalBox();
    }

    createFlight(touristId) {
        var fields = {'Tourist__c' : touristId, 'Trip__c' : this.recordId, 'Status__c' : 'Offer Pending'};
        var objRecordInput = {'apiName' : 'Flight__c', fields};    

        createRecord(objRecordInput)
        .then(response => {
            refreshApex(this.tourists);
        })
        .catch(error => {
            alert('Error: ' + JSON.stringify(error));
        })
    }
}