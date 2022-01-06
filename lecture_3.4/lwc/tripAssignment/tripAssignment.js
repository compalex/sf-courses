import { LightningElement, api } from 'lwc';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';

import AddToTrip from '@salesforce/label/c.AddToTrip';
import TripAssignmentTitle from '@salesforce/label/c.TripAssignmentTitle';
import TripAssignConfirmMsg from '@salesforce/label/c.TripAssignConfirmMsg';
import ConfirmationWindowHeader from '@salesforce/label/c.ConfirmationWindowHeader';
import TouristsAssigned from '@salesforce/label/c.TouristsAssigned';
import OkLabel from '@salesforce/label/c.OkLabel';
import CancelLabel from '@salesforce/label/c.CancelLabel';

import mainTemplate from './mainTemplate.html';
import confirmationTemplate from './confirmationTemplate.html';

import { showToast } from 'c/utility';

export default class TripAssignment extends LightningElement {
    @api recordId;

    touristRegistrator;
    isLoading = false;
    isMainTemplate = true;

    tableData = {
        data: [],
        selectedRows: []
    }

    label = {
        AddToTrip,
        TripAssignmentTitle,
        TripAssignConfirmMsg,
        ConfirmationWindowHeader,
        TouristsAssigned,
        OkLabel,
        CancelLabel
    }

    render() {
        return this.isMainTemplate ? mainTemplate : confirmationTemplate;
    }

    switchTemplate() { 
        this.isMainTemplate = !this.isMainTemplate;
    }

    handleSubmitButton(event) {
        this.touristRegistrator = this.template.querySelector('c-tourist-registrator');
        this.tableData = this.touristRegistrator.getTableData();

        if(this.touristRegistrator.isValidSelection()) {
            this.switchTemplate();
        }
    }

    closeScreen() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleConfirm() {
        this.isLoading = true;
        
        this.touristRegistrator.handleSubmit()
            .then(() => {       
                getRecordNotifyChange([{recordId: this.recordId}]);
                showToast(this, 'Success!', this.label.TouristsAssigned, 'success');
                this.closeScreen();
            })
            .catch(error => {
                showToast(this, 'Error!', error.message, 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
}