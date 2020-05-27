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
        socket.on('disconnect', (reason: string) => {
            if(reason == 'server namespace disconnect') return; // kicked by the server
            
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
        socket.on('find room', (ack: (response: {startFinding: boolean, message: string}) => void) => {
            const userId = WsConnection.getUserId(socket);
            if(this.roomService.getRoomByUserId(userId)) {
                console.log(`User ${userId} already in a room`);
                if(ack) ack({startFinding: false, message: "User already in a room"});
                socket.disconnect();
                return;
            }
            const room = this.roomService.getUserARoom(userId);
            socket.join(room.id);
            console.log(`User ${userId} joined room ${room.id}`)
            if(ack) ack({startFinding: true, message: "User started looking for a room"});

            if(room.isFull()) {
                room.started = true;
                this.userBoardService.createUserBoards(room.users, room.id);
                io.to(room.id).emit('room opened', room.id);
                console.log(`Room ${room.id} opened`);
            }
        })
    }
}
