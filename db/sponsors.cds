namespace my.conference;

using { cuid } from '@sap/cds/common';
using { my.conference.Conferences } from './conferences';

entity Sponsors : cuid {
    name             : String(100);
    sponsorshipLevel : SponsorshipLevel;
}

type SponsorshipLevel : String(20) enum {
    STANDARD;
    PREMIUM;
}

entity Conferences2Sponsors {
    key conference : Association to Conferences;
    key sponsor    : Association to Sponsors;
}
