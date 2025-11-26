using { Conference } from '../db/schema';

service ConferenceService @(path:'/conferences') {

    entity Conferences as projection on Conference;

}
