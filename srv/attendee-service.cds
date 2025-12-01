using { Attendee, Ticket } from '../db/schema';

service AttendeeService @(path:'/attendee') {

    entity Attendees as projection on Attendee;
    entity Tickets as projection on Ticket;

}
