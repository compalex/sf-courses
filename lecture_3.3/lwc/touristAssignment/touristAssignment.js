import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import TouristsAssigned from '@salesforce/label/c.TouristsAssigned';
import getSuitableTrips from '@salesforce/apex/TripController.getSuitableTrips';

export default class TouristAssignment extends LightningElement {
    touristId;
    tripId;
    trips;
    isError=false;
    hasDetails=false;
    errorMessage;

    label = {
        TouristsAssigned
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
        var fields = {'Tourist__c' : this.touristId, 'Trip__c' : this.tripId, 'Status__c' : 'Requested'};
        var objRecordInput = {'apiName' : 'Flight__c', fields};    

        createRecord(objRecordInput)
        .then(response => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!',
                    message: this.label.TouristsAssigned,
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            alert('Error: ' + JSON.stringify(error));
        })
    }

    loadSuitableTrips() {
        getSuitableTrips({touristId : this.touristId})
        .then(results => {
            this.trips = results;
            this.isError = false;
        })
        .catch(error => {
            this.isError = true;
            this.errorMessage = error.body.message;
        });
    }
}