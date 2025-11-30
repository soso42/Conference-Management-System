using { Attendee } from '../db/schema';

service AttendeeService @(path:'/attendee') {

    entity Attendees as projection on Attendee;

}
