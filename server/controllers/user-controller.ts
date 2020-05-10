import {app} from "../server/server";
import {User} from '../models/user';
import {UserService} from '../services/user-service';

export class UserController {

    url: string = "/user";
    userService: UserService;

    constructor(userService: UserService) {
        this.userService = userService;
    }
    
    init(): void {
        this.getUser();
    }

    getUser() {
        app.get(this.url, (req, res) => {
            const body = JSON.parse(req.body);

            this.userService.getUserById(body.userId)
                .then((user: User) => {
                    res.sendStatus(200).send(JSON.stringify(user));
                })
                .catch((error: string) => {
                    res.sendStatus(404).send({
                        message: error
                    });
                });
        });
    }
}

