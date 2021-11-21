import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

import NotEnoughSeats from '@salesforce/label/c.NotEnoughSeats';
import NoTouristsSelected from '@salesforce/label/c.NoTouristsSelected';
import TripAssignmentTitle from '@salesforce/label/c.TripAssignmentTitle';
import TripAssignConfirmMsg from '@salesforce/label/c.TripAssignConfirmMsg';
import TouristsAssigned from '@salesforce/label/c.TouristsAssigned';
import AddToTrip from '@salesforce/label/c.AddToTrip';
import NoSuitableTourists from '@salesforce/label/c.NoSuitableTourists';

import AVAILABLE_SEATS_FIELD from '@salesforce/schema/Trip__c.Available_seats__c';

import insertFlights from '@salesforce/apex/TripController.insertFlights';

import { showToast } from 'c/utility';

export default class TouristRegistrator extends LightningElement {
    @api recordId;
    @api tourists;

    isLoading = false;

    @wire(getRecord, {recordId: '$recordId', fields: [AVAILABLE_SEATS_FIELD]})
    trip;

    label = {
        NotEnoughSeats,
        NoTouristsSelected,
        TripAssignmentTitle,
        TripAssignConfirmMsg,
        TouristsAssigned,
        AddToTrip,
        NoSuitableTourists
    };

    handleBtnClick(event) {
        let rowsNum = this.template.querySelector('c-lazy-datatable').selectedRows.length;

        if(!rowsNum) {
            showToast(this, 'Error!', this.label.NoTouristsSelected, 'error');
        } else if(this.trip.data.fields.Available_seats__c.value >= rowsNum) {
            this.showConfirmationWindow();
        } else {
            showToast(this, 'Error!', this.label.NotEnoughSeats, 'error');
        }
    }

    handleSubmitted() {
        this.isLoading = true;
        let selectedRows = this.template.querySelector('c-lazy-datatable').selectedRows;
        let touristIds = selectedRows.map(tourist => tourist.Id);

        insertFlights({touristIds: touristIds, tripId: this.recordId})
        .then(result => {       
            getRecordNotifyChange([{recordId: this.recordId}]);
            this.isLoading = false;
            showToast(this, 'Success!', this.label.TouristsAssigned, 'success');
        })
        .catch(error=> {
            this.isLoading = false;
            showToast(this, 'Error!', error.message, 'error');
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