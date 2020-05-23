import {UserController} from "../controllers/user-controller";
import {HealthController} from "../controllers/health-controller";
import {MatchMaker} from "../websockets/match-maker";
import {RoomController} from "../controllers/room-controller";
import {WsConnection} from "../websockets/ws-connection";
import {WsChat} from "../websockets/ws-chat";
import {RoomService} from "../services/room-service";
import {UserService} from "../services/user-service";
import {UserProvider} from "../providers/user-provider";
import {RoomProvider} from "../providers/room-provider";

export const initialize = () => {
    
    // Services
    const userProvider = new UserProvider();
    const roomProvider = new RoomProvider();
    
    // Providers
    const roomService = new RoomService(roomProvider, userProvider);
    const userService = new UserService(userProvider);

    // Websockets
    const wsConnection = new WsConnection();
    wsConnection.connect(socket => {
        new MatchMaker(roomService, socket);
        new WsChat(roomService, socket);
    })

    //Controllers
    const userController = new UserController(userService);
    userController.init();
    const roomController = new RoomController(roomService);
    roomController.init();
    const healthController = new HealthController();
    healthController.init();
}

