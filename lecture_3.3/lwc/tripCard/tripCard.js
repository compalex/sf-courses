import { LightningElement, api , wire } from 'lwc';
import getImageLink from '@salesforce/apex/TripController.getImageLink';

export default class TripCard extends LightningElement {
    @api record;
    @api recordId;
    @wire (getImageLink, {tripId : '$recordId'}) imageLink;

    handleCardClicked(evt) {
        const cardClickedEvent = new CustomEvent(
            'clicked', 
            {bubbles : true, detail: this.recordId, composed : true});  
        this.dispatchEvent(cardClickedEvent);
    }
}