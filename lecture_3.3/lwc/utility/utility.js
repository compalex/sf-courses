import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const showToast = (cmp, title, message, variant) => {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
    });
    cmp.dispatchEvent(event);
}

export {
    showToast
};