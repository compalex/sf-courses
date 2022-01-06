import { LightningElement, api } from 'lwc';
import NoSuitableTourists from '@salesforce/label/c.NoSuitableTourists';
import getSuitableTouristsCacheable from '@salesforce/apex/TripController.getSuitableTouristsCacheable';
import { showToast } from 'c/utility';

import NAME_FIELD from '@salesforce/schema/Tourist__c.Name';
import EMAIL_FIELD from '@salesforce/schema/Tourist__c.Email__c';
import GENDER_FIELD from '@salesforce/schema/Tourist__c.Gender__c';

const COLUMNS = [
    { 
        label: 'Tourist Name', 
        fieldName: 'nameUrl', 
        type: 'url', 
        typeAttributes: {label: { fieldName: NAME_FIELD.fieldApiName }, target: '_blank'}
    },
    { 
        label: 'Email', 
        fieldName: EMAIL_FIELD.fieldApiName, 
        type: 'email' 
    },
    { 
        label: 'Gender', 
        fieldName: GENDER_FIELD.fieldApiName, 
        type: 'text',
        initialWidth: 150 
    }
];

export default class LazyDatatable extends LightningElement {
    @api tripId;
    @api tableData;

    tourists = [];
    selectedRows = [];
    columns = COLUMNS;
    rowLimit = 5; 
    rowOffSet = 0;

    label = {
        NoSuitableTourists
    };

    connectedCallback() {
        if(this.tableData.data.length) {
            this.tourists = this.tableData.data;
            this.selectedRows = this.tableData.selectedRows;
            this.rowOffSet = this.tableData.rowOffSet;
        } else {
            this.loadData();
        }
    }

    loadData() {
        return getSuitableTouristsCacheable({tripId: this.tripId, limitSize: this.rowLimit, offset: this.rowOffSet})
            .then(result => {
                if (result.length <= this.rowLimit) {
                    this.template.querySelector('lightning-datatable').removeAttribute('enableInfiniteLoading');
                } 

                result = JSON.parse(JSON.stringify(result));
                result = result.map(row => { 
                    row.nameUrl = ('/' + row.Id);
                    return row;
                })
                this.tourists = [...this.tourists, ...result];
            })
            .catch(error => {
                showToast(this, 'Error!', error.message, 'error');
            });
    }

    async loadMoreData(event) {
        const target = event.target;
        target.isLoading = true;
        this.rowOffSet = this.rowOffSet + this.rowLimit;
        this.loadData();
        target.isLoading = false;
    }

    @api
    getTableData() {
        const tableTemplate = this.template.querySelector('lightning-datatable');

        return {
            data: tableTemplate.data,
            selectedRows: tableTemplate.getSelectedRows().map(tourist => tourist.Id),
            rowOffset: this.rowOffSet   
        }
    }
}
