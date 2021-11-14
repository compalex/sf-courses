import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export function getErrorShowToastEvent(message) {
    return new ShowToastEvent({
        title: 'Error!',
        message: message,
        variant: 'error'
    });
}

export function getSuccessShowToastEvent(message) {
    return new ShowToastEvent({
        title: 'Success!',
        message: message,
        variant: 'success'
    });
}