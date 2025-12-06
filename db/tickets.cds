namespace my.conference;

using { cuid } from '@sap/cds/common';
using { my.conference.Attendees } from './attendees';
using { my.conference.Conferences } from './conferences';


entity Tickets : cuid {
    type       : TicketType;
    price      : Integer;

    conference : Association to one Conferences;

    attendee   : Association to one Attendees
                     on attendee.ticket = $self;
}

type TicketType       : String(20) enum {
    REGULAR;
    VIP;
}
