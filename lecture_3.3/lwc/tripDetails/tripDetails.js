import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { showToast } from 'c/utility';
import getWeatherForecast from '@salesforce/apex/TripController.getWeatherDailyForecast';

import LATITUDE_FIELD from '@salesforce/schema/Trip__c.Latitude__c';
import LONGITUDE_FIELD from '@salesforce/schema/Trip__c.Longitude__c';

export default class tripDetails extends LightningElement {
    @api recordId;

    todayTemp;

    @wire (getRecord, {recordId: '$recordId', fields: [LATITUDE_FIELD, LONGITUDE_FIELD]})
    trip;

    @wire(getWeatherForecast, {tripId: '$recordId'})
    weatherForecast({ error, data }) {
        if (data) {
            this.todayTemp = data.Average_Temperature__c;
        } else if (error) {
           showToast(this, 'Error!', error.message, 'error');
        }
    }

    zoomLevel = 10;
    
    get mapMarkers() {
        return [
            {
                location: {
                    Latitude : getFieldValue(this.trip.data, LATITUDE_FIELD),
                    Longitude : getFieldValue(this.trip.data, LONGITUDE_FIELD),
                },
            },
        ];
    }
}