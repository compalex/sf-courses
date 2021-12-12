import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const showToast = (cmp, title, message, variant) => {
    const event = new ShowToastEvent({
        title,
        message: message,
        variant
    });
    cmp.dispatchEvent(event);
}

const getUrlParamValue = (key) => {
    return new URL(window.location.href).searchParams.get(key);
}

export {
    showToast,
    getUrlParamValue
}