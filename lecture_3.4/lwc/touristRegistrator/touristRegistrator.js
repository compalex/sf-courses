import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

import NotEnoughSeats from '@salesforce/label/c.NotEnoughSeats';
import NoTouristsSelected from '@salesforce/label/c.NoTouristsSelected';
import NoSuitableTourists from '@salesforce/label/c.NoSuitableTourists';

import AVAILABLE_SEATS_FIELD from '@salesforce/schema/Trip__c.Available_seats__c';

import insertFlights from '@salesforce/apex/TripController.insertFlights';

import { showToast } from 'c/utility';

export default class TouristRegistrator extends LightningElement {
    @api tripId;
    @api tableData;

    label = {
        NotEnoughSeats,
        NoTouristsSelected,
        NoSuitableTourists
    };

    isLoading = false;

    @wire(getRecord, {recordId: '$tripId', fields: [AVAILABLE_SEATS_FIELD]})
    trip;

    @api
    isValidSelection() {
        const rowsNum = this.getTableData().selectedRows.length;
        let isValid = false;

        if(!rowsNum) {
            showToast(this, 'Error!', this.label.NoTouristsSelected, 'error');
        } else if(rowsNum > this.trip.data.fields.Available_seats__c.value) {
            showToast(this, 'Error!', this.label.NotEnoughSeats, 'error');
        } else {
            isValid = true;
        }

        return isValid;
    }

    @api
    handleSubmitted() {
        return insertFlights({touristIds: this.getTableData().selectedRows, tripId: this.tripId});
    }

    @api
    getTableData() {
        return this.template.querySelector('c-lazy-datatable').getTableData();
    }

    get hasAvailableSeats() {
        return (this.trip.data.fields.Available_seats__c.value > 0);
    }
}
