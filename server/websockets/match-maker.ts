import {io} from "../server/server";
import {RoomProvider} from "../provider/room-provider";
import {WsConnection} from "./ws-connection";

export class MatchMaker {
    
    roomProvider: RoomProvider;
    
    constructor(roomProvider: RoomProvider, socket: any) {
        this.roomProvider = roomProvider;
        this.onDisconnect(socket);
        this.onFindRoom(socket);
    }
    
    onDisconnect(socket: any) {
        socket.on('disconnect', () => {
            const userId = WsConnection.getUserId(socket);

            console.log(`User ${userId} disconnected`)

            const room = this.roomProvider.removeUserFromRoom(userId);
            if(!room) return;
            if(room.started || room.users.length == 0) {
                if(room.users.length > 0) io.to(room.id).emit('room closed');
                this.roomProvider.deleteRoom(room.id);
                console.log(`Room ${room.id} closed`);
            }
        })
    }
    
    onFindRoom(socket: any) {
        socket.on('find room', () => {
            const userId = WsConnection.getUserId(socket);
            const room = this.roomProvider.getUserARoom(userId);
            socket.join(room.id);
            console.log(`User ${userId} joined room ${room.id}`)

            if(room.isFull()) {
                room.started = true;
                io.to(room.id).emit('room opened', room.id);
                console.log(`Room ${room.id} opened`);
            }
        })
    }
}
