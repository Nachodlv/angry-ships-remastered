import {sequelize} from "../../server/server";
﻿import {Model, DataTypes} from 'sequelize';

export class DatabaseUser extends Model {
    public id!: string;
}

DatabaseUser.init({
    id: { type: DataTypes.STRING, primaryKey: true }
}, {sequelize, modelName: 'user'});

// module.exports = User;