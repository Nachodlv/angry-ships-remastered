import {app} from "../server/server";

const User = require('../models/user')

class UserController {

    url: string = "/user";

    init(): void {
        this.getUser();
    }

    getUser() {
        app.get(this.url, (req, res) => {
            const body = JSON.parse(req.body);

            User.findByPk(body.userId)
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

module.exports = UserController;
