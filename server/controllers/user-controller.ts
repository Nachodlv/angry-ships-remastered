import {app} from "../server/server";
import {UserService} from "../services/user-service";

export class UserController {

    url: string = "/user";
    userService: UserService;

    constructor(userProvider: UserService) {
        this.userService = userProvider;
    }
    
    init(): void {
        this.getUser();
        this.postUser();
    }

    postUser() {
        app.post(this.url, (req, res) => {
            const userId = req.body.userId;
            this.userService.createUser(userId).then(user => {
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
            
            this.userService.getUserById(id)
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

