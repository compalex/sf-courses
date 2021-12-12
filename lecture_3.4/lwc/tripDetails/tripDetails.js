import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { showToast } from 'c/utility';
import getWeatherForecast from '@salesforce/apex/TripController.getWeatherDailyForecast';

import TripDetailsTitle from '@salesforce/label/c.TripDetailsTitle';
import Temperature from '@salesforce/label/c.Temperature';

import LATITUDE_FIELD from '@salesforce/schema/Trip__c.Latitude__c';
import LONGITUDE_FIELD from '@salesforce/schema/Trip__c.Longitude__c';

export default class tripDetails extends LightningElement {
    @api tripId;

    todayTemp;
    zoomLevel = 10;

    label = {
        TripDetailsTitle,
        Temperature
    }

    @wire (getRecord, {recordId: '$tripId', fields: [LATITUDE_FIELD, LONGITUDE_FIELD]})
    trip;

    @wire(getWeatherForecast, {tripId: '$tripId'})
    weatherForecast({ error, data }) {
        if (data) {
            this.todayTemp = Math.round(data.Average_Temperature__c);
        } else if (error) {
            this.todayTemp = undefined;
            showToast(this, 'Error!', error.message, 'error');
        }
    }
    
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