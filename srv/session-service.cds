using {
    Session,
    Conference
} from '../db/schema';

service SessionService @(path: '/sessions') {

    entity Sessions    as projection on Session;

    entity Conferences as projection on Conference;

}
