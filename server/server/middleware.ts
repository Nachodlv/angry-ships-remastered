import {app} from "./server";
import {firebaseAdmin} from "./firebase-admin";

export const authenticateRoutes = () => app.use((req, res, next) => {
    if(!req.headers.authorization) {
        return res.status(401).send({message: 'Unauthorized'});
    }
    const token = req.headers.authorization.split(" ")[1];
    firebaseAdmin.getId(token).then(userId => {
        req.body.userId = userId;
        return next();
    }).catch(error => {
        return res.status(400).send({message: error});
    })
});