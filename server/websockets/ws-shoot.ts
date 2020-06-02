import {RoomService} from "../services/room-service";
import {UserBoardService} from "../services/user-board-service";
import {WsConnection} from "./ws-connection";
import {ShootResult} from "../models/websocket/user-board";
import {Point} from "../models/websocket/point";
import {Room} from "../models/websocket/room";
import {io} from "../server/server";

export class WsShoot {
    roomService: RoomService;
    userBoardService: UserBoardService;

    constructor(roomService: RoomService, userBoardService: UserBoardService, socket: any) {
        this.roomService = roomService;
        this.userBoardService = userBoardService;
        this.onShootMade(socket);
    }
    
    onShootMade(socket: any) {
        socket.on('shoot', (pointReq: any, ack: (shootResult: ShootResult) => void) => {
            const userId = WsConnection.getUserId(socket);
            const point: Point = Point.fromJson(pointReq);
            const room = this.roomService.getRoomByUserId(userId);
            if(room && this.roomService.isUserTurn(room, userId)) {
                const shootResult = this.userBoardService.makeShoot(room.id, userId, point);
                console.log(`User ${userId} shoot. ${shootResult.toString()}`)
                if(shootResult.isValid) {
                    this.emitNextTurn(room);
                    this.emitShoot(socket, room.id, point);
                }
                if(ack) ack(shootResult);
            } else {
                if(ack) ack(new ShootResult(false));
            }
        });
    }
    
    emitNextTurn(room: Room) {
        const user = this.roomService.nextTurn(room);
        console.log(`User ${user.userId} turn`)
        io.to(user.socketId).emit('start turn');
    }
    
    emitShoot(socket: any, roomId: string, shoot: Point) {
        socket.broadcast.to(roomId).emit('opponent shoot', shoot);
    }
    
}