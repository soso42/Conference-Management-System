--liquibase formatted sql

--changeset developer:001 labels:v1.0 context:prod

DROP VIEW IF EXISTS SessionService_DraftAdministrativeData;
DROP VIEW IF EXISTS ConferenceService_DraftAdministrativeData;
DROP VIEW IF EXISTS TicketService_Attendees;
DROP VIEW IF EXISTS TicketService_Tickets;
DROP VIEW IF EXISTS SponsorService_Sponsors;
DROP VIEW IF EXISTS SessionService_Conferences;
DROP VIEW IF EXISTS SessionService_Sessions;
DROP VIEW IF EXISTS ConferenceService_Sessions;
DROP VIEW IF EXISTS ConferenceService_Attendees;
DROP VIEW IF EXISTS ConferenceService_Tickets;
DROP VIEW IF EXISTS ConferenceService_Conferences;
DROP VIEW IF EXISTS AttendeeService_Tickets;
DROP VIEW IF EXISTS AttendeeService_Attendees;
DROP TABLE IF EXISTS SessionService_Sessions_drafts;
DROP TABLE IF EXISTS SessionService_Conferences_drafts;
DROP TABLE IF EXISTS ConferenceService_Sessions_drafts;
DROP TABLE IF EXISTS ConferenceService_Conferences_drafts;
DROP TABLE IF EXISTS DRAFT_DraftAdministrativeData;
DROP TABLE IF EXISTS cds_outbox_Messages;
DROP TABLE IF EXISTS my_conference_Conferences2Sponsors;
DROP TABLE IF EXISTS my_conference_Sponsors;
DROP TABLE IF EXISTS my_conference_Sessions;
DROP TABLE IF EXISTS my_conference_Conferences;
DROP TABLE IF EXISTS my_conference_Tickets;
DROP TABLE IF EXISTS my_conference_Attendees;

CREATE TABLE my_conference_Attendees
(
    ID        VARCHAR(36) NOT NULL,
    firstName VARCHAR(100),
    lastName  VARCHAR(100),
    email     VARCHAR(100),
    ticket_ID VARCHAR(36),
    PRIMARY KEY (ID)
);


CREATE TABLE my_conference_Tickets
(
    ID            VARCHAR(36) NOT NULL,
    type          VARCHAR(20),
    price         INTEGER,
    conference_ID VARCHAR(36),
    PRIMARY KEY (ID)
);


CREATE TABLE my_conference_Conferences
(
    ID          VARCHAR(36) NOT NULL,
    name        VARCHAR(100),
    location    VARCHAR(100),
    description VARCHAR(1000),
    startDate   DATE,
    endDate     DATE,
    PRIMARY KEY (ID)
);


CREATE TABLE my_conference_Sessions
(
    ID            VARCHAR(36) NOT NULL,
    title         VARCHAR(100),
    speaker       VARCHAR(100),
    startTime     TIME,
    endTime       TIME,
    conference_ID VARCHAR(36),
    PRIMARY KEY (ID)
);


CREATE TABLE my_conference_Sponsors
(
    ID               VARCHAR(36) NOT NULL,
    name             VARCHAR(100),
    sponsorshipLevel VARCHAR(20),
    PRIMARY KEY (ID)
);


CREATE TABLE my_conference_Conferences2Sponsors
(
    conference_ID VARCHAR(36) NOT NULL,
    sponsor_ID    VARCHAR(36) NOT NULL,
    PRIMARY KEY (conference_ID, sponsor_ID)
);


CREATE TABLE cds_outbox_Messages
(
    ID                   VARCHAR(36) NOT NULL,
    timestamp            TIMESTAMP,
    target               VARCHAR(255),
    msg                  TEXT,
    attempts             INTEGER DEFAULT 0,
    partition            INTEGER DEFAULT 0,
    lastError            TEXT,
    lastAttemptTimestamp TIMESTAMP,
    status               VARCHAR(23),
    PRIMARY KEY (ID)
);


CREATE TABLE DRAFT_DraftAdministrativeData
(
    DraftUUID                    VARCHAR(36) NOT NULL,
    CreationDateTime             TIMESTAMP,
    CreatedByUser                VARCHAR(256),
    CreatedByUserDescription     VARCHAR(256),
    DraftIsCreatedByMe           BOOLEAN,
    LastChangeDateTime           TIMESTAMP,
    LastChangedByUser            VARCHAR(256),
    LastChangedByUserDescription VARCHAR(256),
    InProcessByUser              VARCHAR(256),
    InProcessByUserDescription   VARCHAR(256),
    DraftIsProcessedByMe         BOOLEAN,
    DraftMessages                TEXT,
    PRIMARY KEY (DraftUUID)
);


CREATE TABLE ConferenceService_Conferences_drafts
(
    ID                                VARCHAR(36)   NOT NULL,
    name                              VARCHAR(100)  NULL,
    location                          VARCHAR(100)  NULL,
    description                       VARCHAR(1000) NULL,
    startDate                         DATE          NULL,
    endDate                           DATE          NULL,
    IsActiveEntity                    BOOLEAN,
    HasActiveEntity                   BOOLEAN,
    HasDraftEntity                    BOOLEAN,
    DraftAdministrativeData_DraftUUID VARCHAR(36)   NOT NULL,
    PRIMARY KEY (ID)
);


CREATE TABLE ConferenceService_Sessions_drafts
(
    ID                                VARCHAR(36)  NOT NULL,
    title                             VARCHAR(100) NULL,
    speaker                           VARCHAR(100) NULL,
    startTime                         TIME         NULL,
    endTime                           TIME         NULL,
    conference_ID                     VARCHAR(36)  NULL,
    IsActiveEntity                    BOOLEAN,
    HasActiveEntity                   BOOLEAN,
    HasDraftEntity                    BOOLEAN,
    DraftAdministrativeData_DraftUUID VARCHAR(36)  NOT NULL,
    PRIMARY KEY (ID)
);


CREATE TABLE SessionService_Conferences_drafts
(
    ID                                VARCHAR(36)   NOT NULL,
    name                              VARCHAR(100)  NULL,
    location                          VARCHAR(100)  NULL,
    description                       VARCHAR(1000) NULL,
    startDate                         DATE          NULL,
    endDate                           DATE          NULL,
    IsActiveEntity                    BOOLEAN,
    HasActiveEntity                   BOOLEAN,
    HasDraftEntity                    BOOLEAN,
    DraftAdministrativeData_DraftUUID VARCHAR(36)   NOT NULL,
    PRIMARY KEY (ID)
);


CREATE TABLE SessionService_Sessions_drafts
(
    ID                                VARCHAR(36)  NOT NULL,
    title                             VARCHAR(100) NULL,
    speaker                           VARCHAR(100) NULL,
    startTime                         TIME         NULL,
    endTime                           TIME         NULL,
    conference_ID                     VARCHAR(36)  NULL,
    IsActiveEntity                    BOOLEAN,
    HasActiveEntity                   BOOLEAN,
    HasDraftEntity                    BOOLEAN,
    DraftAdministrativeData_DraftUUID VARCHAR(36)  NOT NULL,
    PRIMARY KEY (ID)
);


CREATE VIEW AttendeeService_Attendees AS
SELECT Attendees_0.ID,
       Attendees_0.firstName,
       Attendees_0.lastName,
       Attendees_0.email,
       Attendees_0.ticket_ID
FROM my_conference_Attendees AS Attendees_0;


CREATE VIEW AttendeeService_Tickets AS
SELECT Tickets_0.ID,
       Tickets_0.type,
       Tickets_0.price,
       Tickets_0.conference_ID
FROM my_conference_Tickets AS Tickets_0;


CREATE VIEW ConferenceService_Conferences AS
SELECT Conferences_0.ID,
       Conferences_0.name,
       Conferences_0.location,
       Conferences_0.description,
       Conferences_0.startDate,
       Conferences_0.endDate
FROM my_conference_Conferences AS Conferences_0;


CREATE VIEW ConferenceService_Tickets AS
SELECT Tickets_0.ID,
       Tickets_0.type,
       Tickets_0.price,
       Tickets_0.conference_ID
FROM my_conference_Tickets AS Tickets_0;


CREATE VIEW ConferenceService_Attendees AS
SELECT Attendees_0.ID,
       Attendees_0.firstName,
       Attendees_0.lastName,
       Attendees_0.email,
       Attendees_0.ticket_ID
FROM my_conference_Attendees AS Attendees_0;


CREATE VIEW ConferenceService_Sessions AS
SELECT Sessions_0.ID,
       Sessions_0.title,
       Sessions_0.speaker,
       Sessions_0.startTime,
       Sessions_0.endTime,
       Sessions_0.conference_ID
FROM my_conference_Sessions AS Sessions_0;


CREATE VIEW SessionService_Sessions AS
SELECT Sessions_0.ID,
       Sessions_0.title,
       Sessions_0.speaker,
       Sessions_0.startTime,
       Sessions_0.endTime,
       Sessions_0.conference_ID
FROM my_conference_Sessions AS Sessions_0;


CREATE VIEW SessionService_Conferences AS
SELECT Conferences_0.ID,
       Conferences_0.name,
       Conferences_0.location,
       Conferences_0.description,
       Conferences_0.startDate,
       Conferences_0.endDate
FROM my_conference_Conferences AS Conferences_0;


CREATE VIEW SponsorService_Sponsors AS
SELECT Sponsors_0.ID,
       Sponsors_0.name,
       Sponsors_0.sponsorshipLevel
FROM my_conference_Sponsors AS Sponsors_0;


CREATE VIEW TicketService_Tickets AS
SELECT Tickets_0.ID,
       Tickets_0.type,
       Tickets_0.price,
       Tickets_0.conference_ID
FROM my_conference_Tickets AS Tickets_0;


CREATE VIEW TicketService_Attendees AS
SELECT Attendees_0.ID,
       Attendees_0.firstName,
       Attendees_0.lastName,
       Attendees_0.email,
       Attendees_0.ticket_ID
FROM my_conference_Attendees AS Attendees_0;


CREATE VIEW ConferenceService_DraftAdministrativeData AS
SELECT DraftAdministrativeData.DraftUUID,
       DraftAdministrativeData.CreationDateTime,
       DraftAdministrativeData.CreatedByUser,
       DraftAdministrativeData.CreatedByUserDescription,
       DraftAdministrativeData.DraftIsCreatedByMe,
       DraftAdministrativeData.LastChangeDateTime,
       DraftAdministrativeData.LastChangedByUser,
       DraftAdministrativeData.LastChangedByUserDescription,
       DraftAdministrativeData.InProcessByUser,
       DraftAdministrativeData.InProcessByUserDescription,
       DraftAdministrativeData.DraftIsProcessedByMe,
       DraftAdministrativeData.DraftMessages
FROM DRAFT_DraftAdministrativeData AS DraftAdministrativeData;


CREATE VIEW SessionService_DraftAdministrativeData AS
SELECT DraftAdministrativeData.DraftUUID,
       DraftAdministrativeData.CreationDateTime,
       DraftAdministrativeData.CreatedByUser,
       DraftAdministrativeData.CreatedByUserDescription,
       DraftAdministrativeData.DraftIsCreatedByMe,
       DraftAdministrativeData.LastChangeDateTime,
       DraftAdministrativeData.LastChangedByUser,
       DraftAdministrativeData.LastChangedByUserDescription,
       DraftAdministrativeData.InProcessByUser,
       DraftAdministrativeData.InProcessByUserDescription,
       DraftAdministrativeData.DraftIsProcessedByMe,
       DraftAdministrativeData.DraftMessages
FROM DRAFT_DraftAdministrativeData AS DraftAdministrativeData;

