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
import {UserBoardProvider} from "../providers/user-board-provider";
import {UserBoardService} from "../services/user-board-service";
import {WsBoatPlacement} from "../websockets/ws-boat-placement";

export const initialize = () => {
    
    // Providers
    const userProvider = new UserProvider();
    const roomProvider = new RoomProvider();
    const userBoardProvider = new UserBoardProvider();
    
    // Services
    const roomService = new RoomService(roomProvider);
    const userService = new UserService(userProvider);
    const userBoardService = new UserBoardService(userBoardProvider);

    // Websockets
    const wsConnection = new WsConnection();
    wsConnection.connect(socket => {
        new MatchMaker(roomService, userBoardService, socket);
        new WsChat(roomService, socket);
        new WsBoatPlacement(userBoardService, roomService, socket);
    })

    //Controllers
    const userController = new UserController(userService);
    userController.init();
    const roomController = new RoomController(roomService);
    roomController.init();
    const healthController = new HealthController();
    healthController.init();
}

