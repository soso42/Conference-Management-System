namespace my.conference;

using { cuid } from '@sap/cds/common';
using { my.conference.Conferences } from './conferences';

entity Sessions : cuid {
    title      : String(100);
    speaker    : String(100);
    startTime  : Time;
    endTime    : Time;

    conference : Association to one Conferences;
}
