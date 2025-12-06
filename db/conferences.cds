namespace my.conference;

using { cuid } from '@sap/cds/common';
using { my.conference.Tickets } from './tickets';
using { my.conference.Sessions } from './sessions';

entity Conferences : cuid {
    name        : String(100);
    location    : String(100);
    description : String(1000);
    startDate   : Date;
    endDate     : Date;

    tickets     : Association to many Tickets
                      on tickets.conference = $self;

    sessions    : Composition of many Sessions
                      on sessions.conference = $self;
}
