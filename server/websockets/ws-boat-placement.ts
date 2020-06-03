import {UserBoardService} from "../services/user-board-service";
import {Boat} from "../models/websocket/boat";
import {WsConnection} from "./ws-connection";
import {UserBoardState} from "../models/websocket/user-board";
import {RoomService} from "../services/room-service";
import {io} from "../server/server";
import {WsShoot} from "./ws-shoot";

export class WsBoatPlacement {
    userBoardService: UserBoardService;
    roomService: RoomService;
    wsShoot: WsShoot;

    constructor(userBoardService: UserBoardService, roomService: RoomService, wsShoot: WsShoot, socket: any) {
        this.userBoardService = userBoardService;
        this.roomService = roomService;
        this.wsShoot = wsShoot;
        this.onPlaceBoats(socket);
        this.onRandomPlaceBoats(socket);
    }

    onPlaceBoats(socket: any) {
        socket.on('place boats', (reqBoats: any, ack: (boats: Boat[], message: string) => void) => {
            const boats = reqBoats.boats.map((boat: any) => Boat.fromJson(boat));
            const userId = WsConnection.getUserId(socket);
            const userBoard = this.userBoardService.getUserBoardByUserId(userId);
            let message: string;
            let boatsNotPlaced: Boat[] = [];
            
            if(userBoard && userBoard.state == UserBoardState.PLACING_BOATS) {
                boatsNotPlaced = this.userBoardService.placeBoats(userBoard, boats);
                if(boatsNotPlaced.length == 0) {
                    userBoard.state = UserBoardState.READY;
                    const roomId = userBoard.roomId;
                    socket.broadcast.to(userBoard.roomId).emit('opponent placed boats');
                    if(this.userBoardService.areAllUserBoardsReady(roomId)) this.initializeRoom(roomId);
                    message = "All boats placed correctly";
                } else message = "Some boats could not be placed";
                console.log(`User ${userId} placed ${boats.length - boatsNotPlaced.length} boats. Boats with errors: ${boatsNotPlaced.length}`);
            } else {
                message ="User is not on a started room";
            }
            
            if(ack) ack(boatsNotPlaced, message);
        })
    }

    onRandomPlaceBoats(socket: any) {
        socket.on('place boats randomly', (reqBoats: any, ack: (boatsWithErrors: Boat[], boats: Boat[]) => void) => {
            const boats = reqBoats.boats.map((boat: any) => Boat.fromJson(boat));
            const userId = WsConnection.getUserId(socket);
            const userBoard = this.userBoardService.getUserBoardByUserId(userId);
            let newBoats: Boat[] = [];
            let boatsWithErrors: Boat[] = [];
            if(userBoard && userBoard.state == UserBoardState.PLACING_BOATS) {
                boatsWithErrors = this.userBoardService.placeBoats(userBoard, boats, false);
                newBoats = this.userBoardService.placeRandomBoats(userBoard);
                userBoard.state = UserBoardState.READY;
                console.log(`User ${userId} placed ${newBoats.length} boats randomly`)
            } else {
                console.log(`User ${userId} not in a room`);
            }
            
            if(ack) ack(boatsWithErrors, newBoats);
        })
    }
    
    private initializeRoom(roomId: string) {
        const room = this.roomService.markRoomAsPlaying(roomId);
        if(!room) return;
        this.wsShoot.emitTurn(room, room.users[0]);
        console.log(`Room ${roomId} started playing`);
    }
}