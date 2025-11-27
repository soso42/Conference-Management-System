@cds.persistence.name: 'conferences'
entity Conference {
    key id          : UUID;
        name        : String(100);
        location    : String(100);
        description : String(1000);

        @cds.persistence.name: 'start_date'
        startDate   : Date;

        @cds.persistence.name: 'end_date'
        endDate     : Date;
}

@cds.persistence.name: 'sessions'
entity Session {
    key id         : UUID;
        title      : String(100);
        speaker    : String(100);

        @cds.persistence.name: 'start_time'
        startTime  : Time;

        @cds.persistence.name: 'end_time'
        endTime    : Time;
        conference : Association to one Conference @(cds.persistence.foreignKey: 'conference_id');
}

type SponsorshipLevel : String(20) enum {
    STANDARD;
    PREMIUM;
}

@cds.persistence.name: 'sponsors'
entity Sponsor {
    key id               : UUID;
        name             : String(100);

        @cds.persistence.name: 'sponsorship_level'
        sponsorshipLevel : SponsorshipLevel;
}

@cds.persistence.name: 'm2m_conferences_sponsors'
entity Conference2Sponsor {
    key conference : Association to Conference;
    key sponsor    : Association to Sponsor;
}

type TicketType : String(20) enum {
    REGULAR;
    VIP;
}

@cds.persistence.name: 'tickets'
entity Ticket {
    key id         : UUID;
        type       : TicketType;
        price      : Integer;

        conference : Association to one Conference;
}
