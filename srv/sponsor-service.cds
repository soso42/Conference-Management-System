using { my.cms.Sponsor as Sponsor } from '../db/schema';

service SponsorService @(path: '/sponsors') {

    entity Sponsors as projection on Sponsor;

}
