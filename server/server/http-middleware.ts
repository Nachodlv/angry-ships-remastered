import {app} from "./server";
import {firebaseAdmin} from "./firebase-admin";

const authenticateFunction = (req: any, res:any, next:any) => { // check the types of the parameters
    if(!req.headers.authorization) {
        return res.status(401).send({message: 'Unauthorized'});
    }
    const token = req.headers.authorization.split("Bearer ")[1];
    return firebaseAdmin.getId(token).then(userId => {
        req.body.userId = userId;
        return next();
    }).catch(error => {
        return res.status(400).send({message: error});
    })
};

export const authenticateRoutes = () => {
    app.use(authenticateFunction);
}