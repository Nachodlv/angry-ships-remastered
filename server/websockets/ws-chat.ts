import {RoomProvider} from "../provider/room-provider";
import {Message} from "../models/websocket/message";
import {WsConnection} from "./ws-connection";

export class WsChat {
    roomProvider: RoomProvider;
    
    constructor(roomProvider: RoomProvider, socket: any) {
        this.roomProvider = roomProvider;
        this.onMessage(socket);
    }
    
    onMessage(socket: any) {
        socket.on('message', (message: Message) => {
            const room = this.roomProvider.getRoomByUserId(WsConnection.getUserId(socket));
            
            if(!room) {
                socket.emit('error', 'You need to be in a room to send a message');
            } else if(!room.started) {
                socket.emit('error', 'The room need to be open to send a message');
            } else {
                console.log(`Message [${message.userId}]: ${message.text}`)
                room.messages.push(message);
                socket.broadcast.to(room.id).emit('message', message);
            }
        });
    } 
}