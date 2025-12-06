using { my.conference as my } from '../db/schema';

service AttendeeService @(path:'/attendee') {

    entity Attendees as projection on my.Attendees;
    entity Tickets as projection on my.Tickets;

    action registerAttendee(attendeeId: String, conferenceId: String) returns String;
}
