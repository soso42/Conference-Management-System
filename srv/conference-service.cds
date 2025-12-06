using { my.conference as my } from '../db/schema';

service ConferenceService @(path: '/conferences') {

    entity Conferences as
        projection on my.Conferences {
            key ID,
            *,
            tickets,
            virtual null as numOfSessions : Integer
        }
        actions {
            action cancelConference() returns String;
        }

    entity Tickets     as projection on my.Tickets;
    entity Attendees   as projection on my.Attendees;

}
