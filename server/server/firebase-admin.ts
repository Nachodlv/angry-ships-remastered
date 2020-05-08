import * as admin from 'firebase-admin';

class FirebaseAdmin {
    
    init(): void {
        const serviceAccount = require("../credentials/serviceAccountKey.json");
        
        admin.initializeApp({
            credential: admin.credential.cert(serviceAccount),
            databaseURL: "https://angry-ships.firebaseio.com"
        });
        
        
    }
    
    getId(token: string): Promise<string> {
        return admin.auth().verifyIdToken(token).then((decodedToken) => {
            return decodedToken.uid;
        })
    }
    
    getToken() {
        admin.auth().createCustomToken('ci0FOWcUwdRSu3vp0K5DReeFmA82').then(token => {
            console.log('Token: ' + token);
        }).catch(error => {
            console.log(error);
        })
    }
}

export const firebaseAdmin = new FirebaseAdmin();
firebaseAdmin.init();