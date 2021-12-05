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

import getSuitableTrips from '@salesforce/apex/TripController.getSuitableTrips';

import { showToast } from 'c/utility';

export default class TouristAssignment extends LightningElement {
    touristId;
    tripId;
    isLoading = false;
    hasDetail = false;

    label = {
        TripTitle,
        TouristsAssigned,
        TouristAssignConfirmMsg
    };

    @wire(getSuitableTrips, {touristId : '$touristId'})
    trips;

    connectedCallback() {
        const param = 'touristId';
        this.touristId = this.getUrlParamValue(window.location.href, param);
        this.hasDetails = false;
    }
    
    getUrlParamValue(url, key) {
        return new URL(url).searchParams.get(key);
    }

    handleCardClicked(event) {
        this.tripId = event.detail;
        this.hasDetails = true;
    }

    handleBtnClick(event) {
        this.showConfirmationWindow();
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
            .then(() => {
                refreshApex(this.trips);
                this.hasDetails = false;
                showToast(this, 'Success!', this.label.TouristsAssigned, 'success');
            })
            .catch(error => {
                
                showToast(this, 'Error!', error.body.message, 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    get isDisabled() {
        return !this.hasDetails;
    }
}