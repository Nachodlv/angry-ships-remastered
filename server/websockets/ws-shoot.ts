import {RoomService} from "../services/room-service";
import {UserBoardService} from "../services/user-board-service";
import {WsConnection} from "./ws-connection";
import {ShootResult} from "../models/websocket/user-board";
import {Point} from "../models/websocket/point";
import {Room, RoomState} from "../models/websocket/room";
import {io} from "../server/server";
import {WsRoom} from "./ws-room";
import {UserService} from "../services/user-service";

export class WsShoot {
    roomService: RoomService;
    userBoardService: UserBoardService;
    userService: UserService;
    wsRoom: WsRoom;

    constructor(roomService: RoomService, userBoardService: UserBoardService, userService: UserService, wsRoom: WsRoom, socket: any) {
        this.roomService = roomService;
        this.userBoardService = userBoardService;
        this.wsRoom = wsRoom;
        this.userService = userService;
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
                this.makeShoot(room, userId, shootResult, ack);
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
                    this.makeShoot(room, userId, shootResult, ack);
                    return;
                }
            }
            if(ack) ack(new ShootResult(false, new Point(0, 0)));

        });
    }
    
    emitTurn( room: Room, userId: string) {
        const userBoard = this.userBoardService.getUserBoardByUserId(userId);
        const socketId = this.userService.getSocketId(userId);
        if(userBoard && socketId) {
            userBoard.turnTimeout = setTimeout(() => this.turnTimeOut(room, userId, socketId), Room.SECONDS_PER_TURN * 1000);
            console.log(`User ${userId} turn`)
            io.to(socketId).emit('start turn');
        }
        
    }
    
    private turnTimeOut(room: Room, userId: string, socketId: string) {
        if(room.roomState != RoomState.PLAYING) return;
        const shootResult = this.makeRandomShoot(room, userId);
        if(shootResult) {
            console.log(`User ${userId} turn timeout`)
            io.to(socketId).emit('turn timeout', shootResult);
            this.makeShoot(room, userId, shootResult, (_)=>{});
        }
    }
    
    private makeRandomShoot(room: Room, userId: string): ShootResult | undefined{
        if(this.roomService.isUserTurn(room, userId)) {
            return this.userBoardService.makeRandomShoot(room.id, userId);
        } else {
            return undefined;
        }
    }
    
    private makeShoot(room: Room, userId: string, shootResult: ShootResult, ack: (shootResult: ShootResult) => void) {
        console.log(`User ${userId} shoot at ${shootResult.point.toString()}. ${shootResult.toString()}`)
        if(shootResult.isValid) {
            const user = shootResult.boatShoot? userId : this.roomService.nextTurn(room);
            this.emitTurn(room, user);
            room.users.forEach(user => {
                if(user != userId) {
                    const socketId = this.userService.getSocketId(user);
                    io.to(socketId).emit('opponent shoot', shootResult);
                }
            });
            const victoryBoard = this.userBoardService.getVictoryBoard(room.id);
            if(victoryBoard) this.wsRoom.emitGameOver(room, victoryBoard.userId);
        }
        if(ack) ack(shootResult);
    }
    
}