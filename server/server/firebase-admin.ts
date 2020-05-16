import * as admin from 'firebase-admin';
import App = admin.app.App;
const jwtDecode = require('jwt-decode');

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
        // const jwtDecoded = jwtDecode(token);
        // const now = Date.now();
        // if(!jwtDecoded) throw new Error('The token is not a valid jwt')
        // if(jwtDecoded.exp < now) throw new Error('The token has expired');
        // if(jwtDecoded.iat > now) throw new Error('The token emission should be in the past');
        // if(jwtDecoded.aud != this.serviceAccount.project_id || 
        //     jwtDecoded.iss != `https://securetoken.google.com/${this.serviceAccount.project_id}`) 
        //     throw new Error('The token has no valid project id');
        // if(!jwtDecoded.sub || jwtDecoded.sub != jwtDecoded.user_id) throw new Error('Not a valid user id');
        // if(jwtDecoded.auth_time > now) throw new Error('The validation time is not valid');
        
        

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
