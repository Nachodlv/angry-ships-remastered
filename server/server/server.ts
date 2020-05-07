﻿import express = require('express');
const startControllers = require('./controllers-initializer.js');

export const app: express.Application = express();

const startServer = () => {
    app.listen(3000, function () {
        console.log('App is listening on port 3000!');
    });
};


startServer();
startControllers();
