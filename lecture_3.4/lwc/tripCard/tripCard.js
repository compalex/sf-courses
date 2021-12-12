import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Trip__c.Name';
import getImageLink from '@salesforce/apex/TripController.getImageLink';

const CARD_WRAPPER_SELECTED_CLASS = 'card-wrapper selected';
const CARD_WRAPPER_UNSELECTED_CLASS = 'card-wrapper';

export default class TripCard extends LightningElement {
    @api tripId;
    @api selectedTripId;

    @wire (getImageLink, {tripId : '$tripId'}) 
    imageLink;

    @wire (getRecord, {recordId: '$tripId', fields: [NAME_FIELD]})
    trip;

    handleCardClicked(evt) {
        this.selectedTripId = this.tripId;
        const cardClickedEvent = new CustomEvent(
            'selected', 
            {bubbles : true, detail: this.tripId, composed : true}
        );  
        this.dispatchEvent(cardClickedEvent);
    }
    
    get cardClass() {
        return (this.tripId === this.selectedTripId) ? CARD_WRAPPER_SELECTED_CLASS : CARD_WRAPPER_UNSELECTED_CLASS;
    }

    get name() {
        return getFieldValue(this.trip.data, NAME_FIELD);
    }
}