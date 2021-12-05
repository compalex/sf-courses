import { LightningElement , api } from 'lwc';

export default class TripCardList extends LightningElement {
    @api trips;
    @api selectedCard;
}