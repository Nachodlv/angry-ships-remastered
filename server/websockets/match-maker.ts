import {io} from "../server/server";
import {RoomProvider} from "../provider/room-provider";
import {Message} from "../models/websocket/message";

export class MatchMaker {
    
    namespace: any;
    roomProvider: RoomProvider;
    
    constructor(roomProvider: RoomProvider) {
        this.roomProvider = roomProvider;
        this.namespace = io.of('/');    
        this.onConnection();
    }
    
    onConnection() {
        this.namespace.on('connection', (socket: any) => {
            const userId = this.getUserId(socket);
            console.log(`User connected with id: ${userId}`)
            this.onMessage(socket);
            this.onDisconnect(socket);
            this.onFindRoom(socket);
        })
    }
    
    onDisconnect(socket: any) {
        socket.on('disconnect', () => {
            const userId = this.getUserId(socket);

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
    
    onMessage(socket: any) {
        socket.on('message', (message: Message) => {
            console.log(message);
        })
    } 
    
    onFindRoom(socket: any) {
        socket.on('find room', () => {
            const userId = this.getUserId(socket);
            const room = this.roomProvider.getUserARoom(userId);
            socket.join(room.id);
            console.log(`User ${userId} joined room ${room.id}`)

            if(room.isFull()) {
                room.started = true;
                io.to(room.id).emit('room opened');
                console.log(`Room ${room.id} opened`);
            }
        })
    }
    
    getUserId(socket: any): string {
        return socket.handshake.query.userId;
    }
}
