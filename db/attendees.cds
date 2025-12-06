namespace my.conference;

using { cuid } from '@sap/cds/common';
using { my.conference.Tickets } from './tickets';

entity Attendees : cuid {

    firstName : String(100);
    lastName  : String(100);
    email     : String(100);

    ticket    : Association to one Tickets;

}
