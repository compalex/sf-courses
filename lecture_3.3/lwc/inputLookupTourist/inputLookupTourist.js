import { LightningElement } from 'lwc';

export default class InputLookupTourist extends LightningElement {
    
    handleTouristSelection(event){
        const selectedEvent = new CustomEvent('selected', { detail: event.target.value });  
        this.dispatchEvent(selectedEvent);
    }
}