import { LightningElement, api } from 'lwc';
import ConfirmationWindowHeader from '@salesforce/label/c.ConfirmationWindowHeader';

export default class ConfirmationWindow extends LightningElement {
    isModalBoxOpen = false;
    headerTxt = ConfirmationWindowHeader;

    @api message;

    @api 
    openModalBox() {
        this.isModalBoxOpen = true;
    }

    closeModalBox() {
        this.isModalBoxOpen = false;
    }

    submitModalBox() { 
        this.dispatchEvent(new CustomEvent('submitted'));
        this.closeModalBox();
    }
}