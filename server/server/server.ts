﻿import express = require('express');
const {Sequelize} = require('sequelize');
export const sequelize = new Sequelize('database', 'user', 'password', {dialect: 'postgres'});

// Models
const User = require('../models/user.js')

// Controllers
const startControllers = require('./controllers-initializer.js');

export const app: express.Application = express();

const startServer = () => {
    app.listen(3000, function () {
        console.log('App is listening on port 3000!');
    });
};

startServer();
startControllers();

sequelize.sync({force: false})
    .then(() => User.create({
    name: "Nacho",
    id: "123"
})).then(() => {
    User.findByPk("123").then((user: User) => {
        console.log(user);
    });
}).then()
