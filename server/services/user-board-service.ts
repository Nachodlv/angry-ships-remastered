﻿import {UserBoardProvider} from "../providers/user-board-provider";
import {UserBoard, UserBoardState} from "../models/websocket/user-board";
import {Boat} from "../models/websocket/boat";
import {RandomBoatGenerator} from "./random-boat-generator";

export class UserBoardService {
    private userBoarProvider: UserBoardProvider;
    
    constructor(userBoardProvider: UserBoardProvider) {
        this.userBoarProvider = userBoardProvider;
    }
    
    createUserBoards(userIds: string[], roomId: string): UserBoard[] {
        return userIds.map(userId => {
            const userBoard = new UserBoard(userId, roomId);
            this.userBoarProvider.createUserBoard(userBoard);
            return userBoard;
        });
    }
    
    getUserBoardByUserId(userId: string): UserBoard | undefined {
        return this.userBoarProvider.getUserBoardByUserId(userId);
    }
    
    deleteUserBoardsByRoomId(roomId: string) {
        this.userBoarProvider.deleteUserBoardByRoomId(roomId);
    }
    
    placeBoats(userBoard: UserBoard, boats: Boat[], allBoats: boolean = true): Boat[] {
        userBoard.boats = [];
        return userBoard.placeBoats(boats, allBoats);
    }
    
    placeRandomBoats(userBoard: UserBoard): Boat[] {
        const boats = new RandomBoatGenerator().getRandomBoats(userBoard);
        boats.forEach(boat => userBoard.boats.push(boat));
        return boats;
    }
    
    areAllUserBoardsReady(roomId: string): boolean {
        return this.userBoarProvider.getUserBoardsByRoomId(roomId).every(board => board.state == UserBoardState.READY);
    }
    
    getRandomUserBoardFromRoomId(roomId: string): UserBoard | undefined {
        const userBoards = this.userBoarProvider.getUserBoardsByRoomId(roomId);
        if(userBoards.length == 0) return undefined;
        const randomIndex = Math.floor(Math.random() * userBoards.length);
        return userBoards[randomIndex];
    }
}