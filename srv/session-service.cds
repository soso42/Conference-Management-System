using {Session} from '../db/schema';

service SessionService @(path: '/sessions') {

    entity Sessions as projection on Session;

}
