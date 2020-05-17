import {DatabaseUser} from "./database/databaseUser";
import {UserFirebase} from "./user-firebase";

export class User {
    constructor(
        public id: string,
        public name: string | undefined,
        public email: string | undefined,
        public imageUrl: string | undefined) {
    }

    static FromFirebaseAndDatabase(userFirebase: UserFirebase, databaseUser: DatabaseUser): User {
        return new User(
            userFirebase.id, 
            userFirebase.name, 
            userFirebase.email, 
            userFirebase.imageUrl);
    }

}