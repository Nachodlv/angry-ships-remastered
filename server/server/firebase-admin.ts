import * as admin from 'firebase-admin';
import App = admin.app.App;
import {UserFirebase} from "../models/user-firebase";

class FirebaseAdmin {
    
    app: App;
    serviceAccount = require("../credentials/serviceAccountKey.json");

    constructor() {
        this.app = admin.initializeApp({
            credential: admin.credential.cert(this.serviceAccount),
            databaseURL: "https://angry-ships-1589056470752.firebaseio.com"
        });
    }
    
    
    getId(token: string): Promise<string> {
        return this.app.auth().verifyIdToken(token).then((decodedToken) => {
            return decodedToken.uid;
        })
    }
    
    getUserById(userId: string): Promise<UserFirebase> {
        return this.app.auth().getUser(userId).then(userRecord => {
            return UserFirebase.FromUserRecord(userRecord);
        })
    }
}

export const firebaseAdmin = new FirebaseAdmin();
