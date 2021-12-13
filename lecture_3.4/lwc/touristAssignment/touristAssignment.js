import { LightningElement, wire} from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

import STATUS_FIELD from '@salesforce/schema/Flight__c.Status__c';
import TOURIST_FIELD from '@salesforce/schema/Flight__c.Tourist__c';
import TRIP_FIELD from '@salesforce/schema/Flight__c.Trip__c';
import FLIGHT_OBJECT from '@salesforce/schema/Flight__c';

import TripTitle from '@salesforce/label/c.TripTitle';
import TouristsAssigned from '@salesforce/label/c.TouristsAssigned';
import TouristAssignConfirmMsg from '@salesforce/label/c.TouristAssignConfirmMsg';
import PickATripMsg from '@salesforce/label/c.PickATripMsg';
import PickTripTitle from '@salesforce/label/c.PickTripTitle';

import getSuitableTrips from '@salesforce/apex/TripController.getSuitableTrips';

import { showToast, getUrlParamValue } from 'c/utility';

export default class TouristAssignment extends LightningElement {
    touristId;
    tripId;
    isSelected = false;
    isLoading = false;

    label = {
        TripTitle,
        TouristsAssigned,
        TouristAssignConfirmMsg,
        PickATripMsg,
        PickTripTitle
    }

    @wire(getSuitableTrips, {touristId : '$touristId'})
    trips;

    connectedCallback() {
        this.touristId = getUrlParamValue('touristId');
    }

    handleTripSelect(event) {
        this.tripId = event.detail;
        this.isSelected = true;
    }

    handleSubmitButton(event) {
        if(this.isSelected) {
            this.template.querySelector('c-confirmation-window').openModalBox();
        } else {
            showToast(this, 'Error!', this.label.PickATripMsg, 'error');
        }
    }

    handleConfirmed() {
        this.isLoading = true;

        const fields = {};
        fields[TOURIST_FIELD.fieldApiName] = this.touristId;
        fields[TRIP_FIELD.fieldApiName] = this.tripId;
        fields[STATUS_FIELD.fieldApiName] = 'Requested';

        const objRecordInput = {apiName : FLIGHT_OBJECT.objectApiName, fields};  

        createRecord(objRecordInput)
            .then(() => {
                refreshApex(this.trips);
                this.tripId = null;
                this.isSelected = false;
                showToast(this, 'Success!', this.label.TouristsAssigned, 'success');
            })
            .catch(error => {
                showToast(this, 'Error!', error.body.message, 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
}