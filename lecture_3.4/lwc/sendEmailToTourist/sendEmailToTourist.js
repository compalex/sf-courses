import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import { showToast } from 'c/utility';
import sendEmailOffer from '@salesforce/apex/SendOfferController.sendEmailOffer';
import EMAIL_FIELD from '@salesforce/schema/Tourist__c.Email__c';

import EmailSent from '@salesforce/label/c.EmailSent';
import EmailConfirmationMsg from '@salesforce/label/c.EmailConfirmationMsg';
import ConfirmationWindowHeader from '@salesforce/label/c.ConfirmationWindowHeader';
import OkLabel from '@salesforce/label/c.OkLabel';
import CancelLabel from '@salesforce/label/c.CancelLabel';

export default class SendEmailToTourist extends LightningElement {
    @api recordId;

    label = {
        EmailSent,
        EmailConfirmationMsg,
        ConfirmationWindowHeader,
        OkLabel,
        CancelLabel
    };

    @wire(getRecord, {recordId: '$recordId', fields: [EMAIL_FIELD]})
    tourist;

    handleConfirm() {
        const subject = 'Trip Offer!';
        const body = 'https://wise-raccoon-lzakup-developer-edition.na162.force.com' + '/s/?touristId=' + this.recordId;
        const toAddress = this.tourist.data.fields.Email__c.value;

        sendEmailOffer({subject, body, toAddress})
            .then(() => {
                showToast(this, 'Success!', this.label.EmailSent, 'success');
            })
            .catch(error => {
                showToast(this, 'Error!', error.message, 'error');
            })
            .finally(() => {
                this.closeAction();
            });
    }

    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}