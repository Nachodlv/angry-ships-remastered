import {RoomService} from "../services/room-service";
import {UserService} from "../services/user-service";
import {Room} from "../models/websocket/room";

export class RoomProvider {
    roomService: RoomService;
    userService: UserService;
    
    constructor(roomService: RoomService, userService: UserService) {
        this.userService = userService;
        this.roomService = roomService;
    }
    
    getRoomById(roomId: string): Room | undefined {
        return this.roomService.getRoomById(roomId);
    }
    
    getUserARoom(userId: string): Room {
        let room = this.roomService.getAvailableRoom();
        if(room) {
            room.users.push(userId);
            return room;
        } else {
            return this.roomService.createRoom(userId);
        }
    }
    
    removeUserFromRoom(userId: string): Room | undefined {
        const room = this.roomService.getRoomByUserId(userId);
        if(room) {
            room.users = room.users.filter(user => user != userId);
        }
        return room;
    }
    
    deleteRoom(roomId: string) {
        this.roomService.deleteRoom(roomId);
    }
}