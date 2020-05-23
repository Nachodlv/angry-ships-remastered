import {io} from "../server/server";
import {WsConnection} from "./ws-connection";
import {RoomService} from "../services/room-service";
import {UserBoardService} from "../services/user-board-service";

export class MatchMaker {
    
    roomService: RoomService;
    userBoardService: UserBoardService;
    
    constructor(roomProvider: RoomService, userBoardService: UserBoardService, socket: any) {
        this.roomService = roomProvider;
        this.userBoardService = userBoardService;
        this.onDisconnect(socket);
        this.onFindRoom(socket);
    }
    
    onDisconnect(socket: any) {
        socket.on('disconnect', () => {
            const userId = WsConnection.getUserId(socket);

            console.log(`User ${userId} disconnected`)

            const room = this.roomService.removeUserFromRoom(userId);
            if(!room) return;
            if(room.started || room.users.length == 0) {
                if(room.started) this.userBoardService.deleteUserBoardsByRoomId(room.id);
                io.to(room.id).emit('room closed');
                this.roomService.deleteRoom(room.id);
                console.log(`Room ${room.id} closed`);
            }
        })
    }
    
    onFindRoom(socket: any) {
        socket.on('find room', () => {
            const userId = WsConnection.getUserId(socket);
            const room = this.roomService.getUserARoom(userId);
            socket.join(room.id);
            console.log(`User ${userId} joined room ${room.id}`)

            if(room.isFull()) {
                room.started = true;
                this.userBoardService.createUserBoards(room.users, room.id);
                io.to(room.id).emit('room opened', room.id);
                console.log(`Room ${room.id} opened`);
            }
        })
    }
}
