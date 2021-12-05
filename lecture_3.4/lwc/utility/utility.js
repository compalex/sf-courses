import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const showToast = (cmp, title, message, variant) => {
    const event = new ShowToastEvent({
        title,
        message: message,
        variant
    });
    cmp.dispatchEvent(event);
}

export {
    showToast
}