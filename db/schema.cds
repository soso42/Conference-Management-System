
@cds.persistence.name: 'conferences'
entity Conference {
  key id            : UUID;
      name          : String(100);
      location      : String(100);
      description   : String(1000);
      startDate     : Date;
      endDate       : Date;
}

@cds.persistence.name: 'sessions'
entity Session {
  key id            : UUID;
      title         : String(100);
      speaker       : String(100);
      startTime     : Time;
      endTime       : Time;
      conference    : Association to one Conference @(cds.persistence.foreignKey: 'conference_id');
}
