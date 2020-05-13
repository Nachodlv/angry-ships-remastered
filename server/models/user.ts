import {Model, DataTypes} from 'sequelize';
import {sequelize} from '../server/server';

export class User extends Model {}

User.init({
    id: { type: DataTypes.STRING, primaryKey: true },
    name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    surname: {
        type: DataTypes.STRING,
        allowNull: false
    },
    email: {
        type: DataTypes.STRING,
        allowNull: false
    },
    imageUrl: DataTypes.STRING,
}, {sequelize, modelName: 'user'});

// module.exports = User;