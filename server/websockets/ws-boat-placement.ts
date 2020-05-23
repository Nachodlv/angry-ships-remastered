import {UserBoardService} from "../services/user-board-service";
import {Boat} from "../models/websocket/boat";
import {WsConnection} from "./ws-connection";

export class WsBoatPlacement {
    userBoardService: UserBoardService;
    
    constructor(userBoardService: UserBoardService, socket: any) {
        this.userBoardService = userBoardService;
        this.onPlaceBoats(socket);
    }
    
    onPlaceBoats(socket: any) {
        socket.on('place boats', (reqBoats: any[], ack: (boats: Boat[], message: string) => void) => {
            const boats = reqBoats.map((boat: any) => Boat.fromJson(boat));
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
}