using {
    Conference,
    Ticket,
    Attendee
} from '../db/schema';

service ConferenceService @(path: '/conferences') {

    entity Conferences as
        projection on Conference {
            key ID,
            *,
            tickets,
            virtual null as numOfSessions : Integer
        }
        actions {
            action cancelConference() returns String;
        }

    entity Tickets     as projection on Ticket;
    entity Attendees   as projection on Attendee;

//     action cancelConference() returns String;

//     entity Conference {
//         key ID : UUID
//     } actions {
//         action boundAction() returns String;
//     }

}