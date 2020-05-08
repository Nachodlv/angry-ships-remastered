const {Model, DataTypes} = require('sequelize');
const {sequelize} = require('../server/server');

class User extends Model {}

User.init({
    name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    id: { type: DataTypes.STRING, primaryKey: true }
}, {sequelize, modelName: 'user'});

module.exports = User;