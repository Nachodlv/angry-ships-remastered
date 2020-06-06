import {RoomService} from "../services/room-service";
import {UserBoardService} from "../services/user-board-service";
import {WsConnection} from "./ws-connection";
import {ShootResult} from "../models/websocket/user-board";
import {Point} from "../models/websocket/point";
import {Room, UserInRoom} from "../models/websocket/room";
import {io} from "../server/server";

export class WsShoot {
    roomService: RoomService;
    userBoardService: UserBoardService;

    constructor(roomService: RoomService, userBoardService: UserBoardService, socket: any) {
        this.roomService = roomService;
        this.userBoardService = userBoardService;
        this.onShootMade(socket);
        this.onRandomShootMade(socket);
    }
    
    onShootMade(socket: any) {
        socket.on('shoot', (pointReq: any, ack: (shootResult: ShootResult) => void) => {
            const userId = WsConnection.getUserId(socket);
            const point: Point = Point.fromJson(pointReq);
            const room = this.roomService.getRoomByUserId(userId);
            if(room && this.roomService.isUserTurn(room, userId)) {
                const shootResult = this.userBoardService.makeShoot(room.id, userId, point);
                this.makeShoot(socket, room, userId, shootResult, ack);
            } else {
                if(ack) ack(new ShootResult(false, point));
            }
        });
    }
    
    onRandomShootMade(socket: any) {
        socket.on('random shoot', (ack: (shooResult: ShootResult) => void) => {
            const userId = WsConnection.getUserId(socket);
            const room = this.roomService.getRoomByUserId(userId);
            if(room) {
                const shootResult = this.makeRandomShoot(room, userId);
                if(shootResult) {
                    this.makeShoot(socket, room, userId, shootResult, ack);
                    return;
                }
            }
            if(ack) ack(new ShootResult(false, new Point(0, 0)));

        });
    }
    
    emitTurn(room: Room, user: UserInRoom) {
        const userBoard = this.userBoardService.getUserBoardByUserId(user.userId);
        if(userBoard) {
            userBoard.turnTimeout = setTimeout(() => this.turnTimeOut(room, user), Room.SECONDS_PER_TURN * 1000)
        }
        console.log(`User ${user.userId} turn`)
        io.to(user.socketId).emit('start turn');
    }
    
    private turnTimeOut(room: Room, user: UserInRoom) {
        const shootResult = this.makeRandomShoot(room, user.userId);
        if(shootResult) {
            console.log(`User ${user.userId} shoot. ${shootResult.toString()}`)
            console.log(`User ${user.userId} turn timeout`)
            io.to(user.socketId).emit('turn timeout', shootResult);
            this.emitTurn(room, this.roomService.nextTurn(room));
        }
    }
    
    private makeRandomShoot(room: Room, userId: string): ShootResult | undefined{
        if(this.roomService.isUserTurn(room, userId)) {
            return this.userBoardService.makeRandomShoot(userId);
        } else {
            return undefined;
        }
    }
    
    private makeShoot(socket: any, room: Room, userId: string, shootResult: ShootResult, ack: (shootResult: ShootResult) => void) {
        console.log(`User ${userId} shoot. ${shootResult.toString()}`)
        if(shootResult.isValid) {
            const user = this.roomService.nextTurn(room);
            this.emitTurn(room, user);
            socket.broadcast.to(room.id).emit('opponent shoot', shootResult.point);
        }
        if(ack) ack(shootResult);
    }
    
}