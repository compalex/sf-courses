import { LightningElement} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';

import STATUS_FIELD from '@salesforce/schema/Flight__c.Status__c';
import TOURIST_FIELD from '@salesforce/schema/Flight__c.Tourist__c';
import TRIP_FIELD from '@salesforce/schema/Flight__c.Trip__c';
import FLIGHT_OBJECT from '@salesforce/schema/Flight__c';

import TouristsAssigned from '@salesforce/label/c.TouristsAssigned';
import TouristAssignConfirmMsg from '@salesforce/label/c.TouristAssignConfirmMsg';

import getSuitableTrips from '@salesforce/apex/TripController.getSuitableTrips';

import {getErrorShowToastEvent, getSuccessShowToastEvent} from 'c/utility';

export default class TouristAssignment extends LightningElement {
    touristId;
    tripId;
    trips;
    hasDetails=false;

    label = {
        TouristsAssigned,
        TouristAssignConfirmMsg
    };

    handleTouristSelected(evt) {
        this.touristId = evt.detail;
        this.loadSuitableTrips();
    }

    handleCardClicked(evt) {
        this.tripId = evt.detail;
        this.hasDetails = true;
    }

    handleBtnClick(evt) {
        this.showConfirmationWindow();
    }

    loadSuitableTrips() {
        getSuitableTrips({touristId : this.touristId})
        .then(results => {
            this.trips = results;
        })
        .catch(error => {
            this.dispatchEvent(getErrorShowToastEvent(error.message));
        });
    }

    showConfirmationWindow() {
        const modal = this.template.querySelector("c-confirmation-window");
        modal.openModalBox();
    }

    handleSubmitted() {
        const fields = {};
        fields[TOURIST_FIELD.fieldApiName] = this.touristId;
        fields[TRIP_FIELD.fieldApiName] = this.tripId;
        fields[STATUS_FIELD.fieldApiName] = 'Requested';

        const objRecordInput = {apiName : FLIGHT_OBJECT.objectApiName, fields};    

        createRecord(objRecordInput)
        .then(response => {
            this.dispatchEvent(getSuccessShowToastEvent(this.label.TouristsAssigned));
        })
        .catch(error => {
            this.dispatchEvent(getErrorShowToastEvent(error.message));
        })
    }

    get isDisabled() {
        return !this.hasDetails;
    }
}