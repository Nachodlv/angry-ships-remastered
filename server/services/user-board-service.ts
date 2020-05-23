import {UserBoardProvider} from "../providers/user-board-provider";
import {UserBoard} from "../models/websocket/user-board";
import {Boat} from "../models/websocket/boat";

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
    
    placeBoats(userBoard: UserBoard, boats: Boat[]): Boat[] {
        return userBoard.placeBoats(boats);
    }
}