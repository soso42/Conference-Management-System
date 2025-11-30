using { my.cms.Attendee as Attendee } from '../db/schema';

service AttendeeService @(path:'/attendee') {

    entity Attendees as projection on Attendee;

}
