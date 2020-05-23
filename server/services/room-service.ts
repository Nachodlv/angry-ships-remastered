import {Room} from "../models/websocket/room";
import {RoomProvider} from "../providers/room-provider";

export class RoomService {
    roomProvider: RoomProvider;
    
    constructor(roomProvider: RoomProvider) {
        this.roomProvider = roomProvider;
    }
    
    getRoomById(roomId: string): Room | undefined {
        return this.roomProvider.getRoomById(roomId);
    }
    
    getRoomByUserId(userId: string): Room | undefined {
        return this.roomProvider.getRoomByUserId(userId);
    }
    
    getUserARoom(userId: string): Room {
        let room = this.roomProvider.getAvailableRoom();
        if(room) {
            room.users.push(userId);
            return room;
        } else {
            return this.roomProvider.createRoom(userId);
        }
    }
    
    removeUserFromRoom(userId: string): Room | undefined {
        const room = this.roomProvider.getRoomByUserId(userId);
        if(room) {
            room.users = room.users.filter(user => user != userId);
        }
        return room;
    }
    
    deleteRoom(roomId: string) {
        this.roomProvider.deleteRoom(roomId);
    }
}