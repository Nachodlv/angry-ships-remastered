const UserController = require('../controllers/user-controller.js');
const HealthController = require('../controllers/health-controller.js');

const startControllers = () => {
    const userController = new UserController();
    userController.init();
    const healthController = new HealthController();
    healthController.init();
}

module.exports = startControllers;