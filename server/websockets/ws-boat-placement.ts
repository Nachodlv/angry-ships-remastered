import {UserBoardService} from "../services/user-board-service";
import {Boat} from "../models/websocket/boat";
import {WsConnection} from "./ws-connection";

export class WsBoatPlacement {
    userBoardService: UserBoardService;

    constructor(userBoardService: UserBoardService, socket: any) {
        this.userBoardService = userBoardService;
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
            
            if(userBoard) {
                boatsNotPlaced = this.userBoardService.placeBoats(userBoard, boats);
                if(boatsNotPlaced.length == 0) {
                    socket.broadcast.to(userBoard.roomId).emit('opponent placed boats');
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
            if(userBoard) {
                boatsWithErrors = this.userBoardService.placeBoats(userBoard, boats, false);
                newBoats = this.userBoardService.placeRandomBoats(userBoard);
                console.log(`User ${userId} placed ${newBoats.length} boats randomly`)
            } else {
                console.log(`User ${userId} not in a room`);
            }
            
            if(ack) ack(boatsWithErrors, newBoats);
        })
    }
}