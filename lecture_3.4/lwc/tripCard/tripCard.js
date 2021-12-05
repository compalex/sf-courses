import { LightningElement, api , wire } from 'lwc';
import getImageLink from '@salesforce/apex/TripController.getImageLink';

const CARD_WRAPPER_SELECTED_CLASS = 'card-wrapper selected';
const CARD_WRAPPER_UNSELECTED_CLASS = 'card-wrapper';

export default class TripCard extends LightningElement {
    @api record;
    @api recordId;
    @api selectedId;

    @wire (getImageLink, {tripId : '$recordId'}) 
    imageLink;

    handleCardClicked(evt) {
        this.selectedId = this.recordId;
        const cardClickedEvent = new CustomEvent(
            'clicked', 
            {bubbles : true, detail: this.recordId, composed : true});  
        this.dispatchEvent(cardClickedEvent);
    }
    
    get cardClass() {
        return (this.recordId === this.selectedId) ? CARD_WRAPPER_SELECTED_CLASS : CARD_WRAPPER_UNSELECTED_CLASS;
    }
}