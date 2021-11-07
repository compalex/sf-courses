import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getWeatherForecasts from '@salesforce/apex/TripController.getWeatherDailyForecasts';
import LATITUDE_FIELD from '@salesforce/schema/Trip__c.Latitude__c';
import LONGITUDE_FIELD from '@salesforce/schema/Trip__c.Longitude__c';

export default class tripDetails extends LightningElement {
    @api recordId;

    @wire (getRecord, {recordId: '$recordId', fields: [LATITUDE_FIELD, LONGITUDE_FIELD]})
    trip;

    @wire(getWeatherForecasts, {tripId: '$recordId'})
    weatherForecasts;

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