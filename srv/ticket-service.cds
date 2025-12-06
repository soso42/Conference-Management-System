using { my.conference as my } from '../db/schema';

service TicketService @(path: '/ticket') {

    entity Tickets   as
        projection on my.Tickets {
            *,
            attendee
        };

    entity Attendees as projection on my.Attendees;

}
