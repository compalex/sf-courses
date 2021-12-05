import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

import NotEnoughSeats from '@salesforce/label/c.NotEnoughSeats';
import NoTouristsSelected from '@salesforce/label/c.NoTouristsSelected';
import NoSuitableTourists from '@salesforce/label/c.NoSuitableTourists';

import AVAILABLE_SEATS_FIELD from '@salesforce/schema/Trip__c.Available_seats__c';

import insertFlights from '@salesforce/apex/TripController.insertFlights';

import { showToast } from 'c/utility';

export default class TouristRegistrator extends LightningElement {
    @api recordId;
    @api tableData;

    label = {
        NotEnoughSeats,
        NoTouristsSelected,
        NoSuitableTourists
    };

    isLoading = false;

    @wire(getRecord, {recordId: '$recordId', fields: [AVAILABLE_SEATS_FIELD]})
    trip;

    @api
    handleBtnClick() {
        let rowsNum = this.getTableData().selectedRows.length;

        if(!rowsNum) {
            showToast(this, 'Error!', this.label.NoTouristsSelected, 'error');
        } else if(this.trip.data.fields.Available_seats__c.value >= rowsNum) {
            this.dispatchEvent(new CustomEvent('selected'));
        } else {
            showToast(this, 'Error!', this.label.NotEnoughSeats, 'error');
        }
    }

    @api
    handleSubmitted() {
        let touristIds = this.getTableData().selectedRows.map(tourist => tourist.Id);
        return insertFlights({touristIds, tripId: this.recordId});
    }

    @api
    getTableData() {
        return this.template.querySelector('c-lazy-datatable').getTableData();
    }

    get hasAvailableSeats() {
        return (this.trip.data.fields.Available_seats__c.value > 0);
    }
}