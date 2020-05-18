// Express
import express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
export const app: express.Application = express();
const http = require('http').createServer(app);
app.use(bodyParser.json());
app.use(cors());

// Socket.io
export const io = require('socket.io')(http, {origin: "localhost:* chrome-extension://*"});
import {authenticateWebSocket} from "./ws-middleware";
io.use(authenticateWebSocket)

// Sequelize
const {Sequelize} = require('sequelize');
export const sequelize = new Sequelize('database', 'user', 'password', {dialect: 'postgres'});

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

