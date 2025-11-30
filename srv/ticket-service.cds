using {
    my.cms.Ticket as Ticket,
    my.cms.Attendee as Attendee
} from '../db/schema';

service TicketService @(path: '/ticket') {

    entity Tickets   as
        projection on Ticket {
            *,
            attendee
        };

    entity Attendees as projection on Attendee;

}
