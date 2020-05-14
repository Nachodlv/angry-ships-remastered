import {firebaseAdmin} from "./firebase-admin";

﻿﻿export const authenticateWebSocket = (socket: any, next: any) => {
    const token = socket.handshake.headers.authorization.split(" ")[1];
    if(token) {
        firebaseAdmin.getId(token).then(userId => {
            next();
        }).catch(error => {
            console.log(error);
        })
    } else {
        console.log("No Token in ws!")
    }
}