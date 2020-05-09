﻿// Express
import express = require('express');
const bodyParser = require('body-parser');
export const app: express.Application = express();
app.use(bodyParser.json());


// Sequelize
const {Sequelize} = require('sequelize');
export const sequelize = new Sequelize('database', 'user', 'password', {dialect: 'postgres'});
// export const Serializer = require('sequelize-to-json'); not required for now. https://github.com/hauru/sequelize-to-json

// Models
require('../models/user.js');

// Controllers
const startControllers = require('./controllers-initializer.js');

// Middleware
require('./middleware').authenticateRoutes();

const startServer = () => {
    app.listen(3000, function () {
        console.log('App is listening on port 3000!');
    });
};


// Example, remove in the future
sequelize
    .sync({force: false})
    .then(() => {
        startServer();
        startControllers();
    }).catch((error: string) => console.log(error));
    // .then(() => User.create({
    //     name: "Nacho",
    //     id: "123"
    // }))
    // .catch((error: string) => {
    //     console.log(error);
    // })

