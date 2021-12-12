import { LightningElement, api } from 'lwc';

import ConfirmationWindowHeader from '@salesforce/label/c.ConfirmationWindowHeader';
import OkLabel from '@salesforce/label/c.OkLabel';
import CancelLabel from '@salesforce/label/c.CancelLabel';

export default class ConfirmationWindow extends LightningElement {
    @api isModalBoxOpen = false;
    @api message;

    label = {
        ConfirmationWindowHeader,
        OkLabel,
        CancelLabel
    };

    @api 
    openModalBox() {
        this.isModalBoxOpen = true;
    }

    closeModalBox() {
        this.isModalBoxOpen = false;
    }

    submitModalBox() { 
        this.dispatchEvent(new CustomEvent('confirmed'));
        this.isModalBoxOpen = false;
    }
}