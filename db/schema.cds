using {cuid} from '@sap/cds/common';

@cds.persistence.name: 'conferences'
entity Conference : cuid {
    name        : String(100);
    location    : String(100);
    description : String(1000);

    @cds.persistence.name: 'start_date'
    startDate   : Date;

    @cds.persistence.name: 'end_date'
    endDate     : Date;
}

@cds.persistence.name: 'sessions'
entity Session : cuid {
    title      : String(100);
    speaker    : String(100);

    @cds.persistence.name: 'start_time'
    startTime  : Time;

    @cds.persistence.name: 'end_time'
    endTime    : Time;
    conference : Association to one Conference;
}

type SponsorshipLevel : String(20) enum {
    STANDARD;
    PREMIUM;
}

@cds.persistence.name: 'sponsors'
entity Sponsor : cuid {
    name             : String(100);

    @cds.persistence.name: 'sponsorship_level'
    sponsorshipLevel : SponsorshipLevel;
}

@cds.persistence.name: 'm2m_conferences_sponsors'
entity Conference2Sponsor {
    key conference : Association to Conference;
    key sponsor    : Association to Sponsor;
}

type TicketType       : String(20) enum {
    REGULAR;
    VIP;
}

@cds.persistence.name: 'tickets'
entity Ticket : cuid {
    type       : TicketType;
    price      : Integer;

    conference : Association to one Conference;
}

@cds.persistence.name: 'attendees'
entity Attendee : cuid {
    @cds.persistence.name: 'first_name'
    firstName : String(100);

    @cds.persistence.name: 'last_name'
    lastName  : String(100);

    email     : String(100);

    @cds.persistence.name: 'ticket_id'
    ticket    : Association to one Ticket;
}
