import {admin} from "firebase-admin/lib/auth";
import UserRecord = admin.auth.UserRecord;

export class UserFirebase {
    constructor(
        public id: string,
        public name: string | undefined,
        public email: string | undefined,
        public imageUrl: string | undefined) {
    }
    
    static FromUserRecord(userRecord: UserRecord): UserFirebase {
        return new UserFirebase(userRecord.uid, userRecord.displayName, userRecord.email, userRecord.photoURL)
    }
}