import {UserService} from "../services/user-service";
import {UserController} from "../controllers/user-controller";
import {HealthController} from "../controllers/health-controller";
import {RoomService} from "../services/room-service";
import {RoomProvider} from "../provider/room-provider";
import {MatchMaker} from "../websockets/match-maker";
import {UserProvider} from "../provider/user-provider";
import {RoomController} from "../controllers/room-controller";



export const initialize = () => {
    
    // Services
    const userService = new UserService();
    const roomService = new RoomService();
    
    // Providers
    const roomProvider = new RoomProvider(roomService, userService);
    const userProvider = new UserProvider(userService);

    // Websockets
    new MatchMaker(roomProvider);

    //Controllers
    const userController = new UserController(userProvider);
    userController.init();
    const roomController = new RoomController(roomProvider);
    roomController.init();
    const healthController = new HealthController();
    healthController.init();
}

