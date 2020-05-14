﻿import {UserController} from '../controllers/user-controller';
import {UserService} from "../services/user-service";
import {HealthController} from '../controllers/health-controller';

const startControllers = () => {
    const userController = new UserController(new UserService());
    userController.init();
    const healthController = new HealthController();
    healthController.init();
}

module.exports = startControllers;