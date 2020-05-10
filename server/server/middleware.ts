import {app} from "./server";
import {firebaseAdmin} from "./firebase-admin";

// Routes that will be authenticated
const authenticatedRoutes: string[] = [
    '/user*'
];

const authenticateFunction = (req: any, res:any, next:any) => { // check the types of the parameters
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
};

export const authenticateRoutes = () => {
    authenticatedRoutes.forEach(route => app.get(route, authenticateFunction));
}