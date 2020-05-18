import {app} from "../server/server";
import {DatabaseUser} from "../models/database/databaseUser";
import {UserProvider} from "../provider/user-provider";

export class UserController {

    url: string = "/user";
    userProvider: UserProvider;

    constructor(userProvider: UserProvider) {
        this.userProvider = userProvider;
    }
    
    init(): void {
        this.getUser();
        this.postUser();
    }

    postUser() {
        app.post(this.url, (req, res) => {
            const userId = req.body.userId;
            this.userProvider.createUser(userId).then(user => {
                return res.status(200).send({id: user.id})
            }).catch((error: any) => {
                if(error.name == 'SequelizeUniqueConstraintError') {
                    return res.status(409).send({message: "User with that id already exists"})
                }
                return res.status(400).send({
                    message: error
                })
            })
        })
    }
    
    getUser() {
        app.get(`${this.url}/:id`, (req, res) => {
            const id = req.params.id;
            
            this.userProvider.getUserById(id)
                .then(user => {
                    res.status(200).send(user);
                })
                .catch((error: string) => {
                    res.status(404).send({
                        message: error
                    });
                });
        });
    }
}

