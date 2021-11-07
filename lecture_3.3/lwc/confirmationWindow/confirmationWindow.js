import { LightningElement, api } from 'lwc';

export default class ConfirmationWindow extends LightningElement {
    isModalBoxOpen = false;

    @api openModalBox() {
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