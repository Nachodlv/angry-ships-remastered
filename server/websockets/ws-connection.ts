import {io} from "../server/server";
import {UserService} from "../services/user-service";

export class WsConnection {
    
    userService: UserService;

    constructor(userService: UserService) {
        this.userService = userService;
    }

    connect(callback: (socket: any) => void) {
        const namespace = io.of('/');
        namespace.on('connection', (socket: any) => {
            const userId = WsConnection.getUserId(socket);
            this.userService.setSocketId(userId, socket.id);
            console.log(`User connected with id: ${userId}`)
            callback(socket)
        });
    }

    static getUserId(socket: any): string {
        return socket.handshake.query.userId;
    }
}