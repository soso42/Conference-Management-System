using { my.conference as my } from '../db/schema';

service SponsorService @(path: '/sponsors') {

    entity Sponsors as projection on my.Sponsors;

}
