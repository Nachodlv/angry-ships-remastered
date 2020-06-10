import {Room, RoomState} from "../models/websocket/room";
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
    
    getUserARoom(userId: string, isPrivate: boolean = false): Room {
        let room = this.roomProvider.getAvailableRoom();
        if(room && !isPrivate) {
            room.users.push(userId);
            return room;
        } else {
            const room = this.roomProvider.createRoom(userId);
            room.private = isPrivate;
            return room;
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
    
    markRoomAsPlaying(roomId: string): Room | undefined {
        const room = this.roomProvider.getRoomById(roomId);
        if(room && room.roomState == RoomState.PLACING_BOATS) {
            room.users.sort(() => Math.random() - 0.5);
            room.roomState = RoomState.PLAYING;
            return room;
        }
        return undefined;
    }
    
    isUserTurn(room: Room, userId: string): boolean {
        return room.roomState == RoomState.PLAYING &&  room.users[room.currentTurn] == userId;
    }
    
    nextTurn(room: Room): string {
        room.currentTurn = (room.currentTurn + 1) % room.users.length;
        return room.users[room.currentTurn];
    }
    
}