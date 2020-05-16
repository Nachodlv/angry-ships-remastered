import {firebaseAdmin} from "./firebase-admin";

﻿﻿export const authenticateWebSocket = (socket: any, next: any) => {
    const token = socket.handshake.query.token?.split("Bearer ")[1];
    if(token) {
        firebaseAdmin.getId(token).then(userId => {
            socket.handshake.query.userId = userId;
            next();
        }).catch(error => {
            console.log(error);
            return next(new Error('Authentication error'));
        })
    } else {
        console.log("No Token in ws!")
        return next(new Error('Authentication error'))
    }
}