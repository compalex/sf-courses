import { LightningElement} from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';

import STATUS_FIELD from '@salesforce/schema/Flight__c.Status__c';
import TOURIST_FIELD from '@salesforce/schema/Flight__c.Tourist__c';
import TRIP_FIELD from '@salesforce/schema/Flight__c.Trip__c';
import FLIGHT_OBJECT from '@salesforce/schema/Flight__c';

import TripTitle from '@salesforce/label/c.TripTitle';
import TouristsAssigned from '@salesforce/label/c.TouristsAssigned';
import TouristAssignConfirmMsg from '@salesforce/label/c.TouristAssignConfirmMsg';

import getSuitableTrips from '@salesforce/apex/TripController.getSuitableTrips';

import { showToast } from 'c/utility';

export default class TouristAssignment extends LightningElement {
    touristId;
    tripId;
    trips;
    isLoading = false;
    hasDetails=false;

    label = {
        TripTitle,
        TouristsAssigned,
        TouristAssignConfirmMsg
    };

    handleTouristSelected(event) {
        this.touristId = event.detail;
        this.hasDetails = false;
        this.loadSuitableTrips();
    }

    handleCardClicked(event) {
        this.tripId = event.detail;
        this.hasDetails = true;
    }

    handleBtnClick(event) {
        this.showConfirmationWindow();
    }

    loadSuitableTrips() {
        if(!this.touristId) {
            return;
        }

        this.isLoading = true;

        getSuitableTrips({touristId : this.touristId})
        .then(results => {
            this.isLoading = false;
            this.trips = results;
        })
        .catch(error => {
            this.isLoading = false;
            showToast(this, 'Error!', error.message, 'error');
        });
    }

    showConfirmationWindow() {
        const modal = this.template.querySelector("c-confirmation-window");
        modal.openModalBox();
    }

    handleSubmitted() {
        this.isLoading = true;

        const fields = {};
        fields[TOURIST_FIELD.fieldApiName] = this.touristId;
        fields[TRIP_FIELD.fieldApiName] = this.tripId;
        fields[STATUS_FIELD.fieldApiName] = 'Requested';

        const objRecordInput = {apiName : FLIGHT_OBJECT.objectApiName, fields};    

        createRecord(objRecordInput)
        .then(response => {
            this.isLoading = false;
            showToast(this, 'Success!', this.label.TouristsAssigned, 'success');
        })
        .catch(error => {
            this.isLoading = false;
            showToast(this, 'Error!', error.message, 'error');
        })
    }

    get isDisabled() {
        return !this.hasDetails;
    }
}