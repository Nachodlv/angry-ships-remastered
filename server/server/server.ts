// Express
import express = require('express');
const bodyParser = require('body-parser');
export const app: express.Application = express();
const http = require('http').createServer(app);
app.use(bodyParser.json());

// Socket.io
export const io = require('socket.io')(http, {origin: "localhost:* chrome-extension://*"});
import {authenticateWebSocket} from "./ws-middleware";
io.use(authenticateWebSocket)

// Sequelize
const {Sequelize} = require('sequelize');
export const sequelize = new Sequelize('database', 'user', 'password', {dialect: 'postgres'});
// export const Serializer = require('sequelize-to-json'); not required for now. https://github.com/hauru/sequelize-to-json

// Controllers and websockets
import {initialize} from "./initializer";

// Middleware
require('./http-middleware').authenticateRoutes();

const startServer = () => {
    http.listen(3000, function () {
        console.log('App is listening on port 3000!');
    });
};


// Example, remove in the future
sequelize
    .sync({force: true})
    .then(() => {
        startServer();
        initialize();
    }).catch((error: string) => console.log(error));
    // .then(() => User.create({
    //     name: "Nacho",
    //     id: "123"
    // }))
    // .catch((error: string) => {
    //     console.log(error);
    // })

