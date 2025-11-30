using {
    Conference,
    Ticket,
    Attendee
} from '../db/schema';

service ConferenceService @(path: '/conferences') {

    entity Conferences as
        projection on Conference {
            *,
            tickets
        };

    entity Tickets     as projection on Ticket;
    entity Attendees   as projection on Attendee;

}
