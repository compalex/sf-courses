import { LightningElement, api } from 'lwc';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';

import AddToTrip from '@salesforce/label/c.AddToTrip';
import TripAssignmentTitle from '@salesforce/label/c.TripAssignmentTitle';
import TripAssignConfirmMsg from '@salesforce/label/c.TripAssignConfirmMsg';
import ConfirmationWindowHeader from '@salesforce/label/c.ConfirmationWindowHeader';
import TouristsAssigned from '@salesforce/label/c.TouristsAssigned';

import mainTemplate from './mainTemplate.html';
import confirmationTemplate from './confirmationTemplate.html';

import { showToast } from 'c/utility';

export default class TripAssignment extends LightningElement {
    @api recordId;

    childTemplate;
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
        TouristsAssigned
    }

    render() {
        return this.isMainTemplate ? mainTemplate : confirmationTemplate;
    }

    switchTemplate() { 
        this.isMainTemplate = !this.isMainTemplate;
    }

    handleSubmitButton(event) {
        this.childTemplate = this.template.querySelector('c-tourist-registrator');
        this.tableData = this.childTemplate.getTableData();
        this.tableData.selectedRows = this.tableData.selectedRows.map(tourist => tourist.Id);
        this.childTemplate.handleBtnClick(event);
    }

    closeScreen() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleConfirm() {
        this.isLoading = true;
        
        this.childTemplate.handleSubmitted()
            .then(() => {       
                getRecordNotifyChange([{recordId: this.recordId}]);
                showToast(this, 'Success!', this.label.TouristsAssigned, 'success');
            })
            .catch(error => {
                showToast(this, 'Error!', error.message, 'error');
            })
            .finally(() => {
                this.isLoading = false;
                this.closeScreen();
            });
    }
}