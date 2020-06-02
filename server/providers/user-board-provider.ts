import {UserBoard} from "../models/websocket/user-board";

export class UserBoardProvider {
    private userBoards: UserBoard[] = [];
    
    getUserBoard(userId: string, roomId: string): UserBoard | undefined {
        for (let userBoard of this.userBoards) {
            if(userBoard.userId == userId && userBoard.roomId == roomId) return userBoard;
        }
        return undefined;
    }
    
    createUserBoard(userBoard: UserBoard) {
        this.userBoards.push(userBoard);
    }
    
    deleteUserBoardByRoomId(roomId: string) {
        this.userBoards = this.userBoards.filter(board => board.roomId != roomId);
    }
    
    getUserBoardByUserId(userId: string): UserBoard | undefined {
        for (let board of this.userBoards) {
            if(board.userId == userId) return board;
        }
        return undefined;
    }
    
    getUserBoardsByRoomId(roomId: string): UserBoard[] {
        return this.userBoards.filter(board => board.roomId == roomId);
    }
}