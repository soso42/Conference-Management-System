using { my.conference as my } from '../db/schema';

service SessionService @(path: '/sessions') {

    entity Sessions    as projection on my.Sessions;

    entity Conferences as projection on my.Conferences;

}
