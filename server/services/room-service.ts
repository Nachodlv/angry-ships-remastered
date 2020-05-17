import {Room} from "../models/websocket/room";

const { v4: uuidv4 } = require('uuid');

export class RoomService{
    rooms: Room[] = [];
    
    getAvailableRoom(): Room | undefined {
        return this.getRoom(room => !room.isFull());
    }
    
    createRoom(user: string): Room {
        const room = new Room(uuidv4(), [user]);
        this.rooms.push(room);
        return room;
    }
    
    updateRoom(updatedRoom: Room) {
        this.rooms.some((room, index, rooms) => {
            if(room.id == updatedRoom.id) {
                rooms[index] = updatedRoom;
                return true;
            }
            return false;
        })
    }
    
    deleteRoom(id: string) {
        this.rooms = this.rooms.filter(room => room.id != id);
    }
    
    getRoomByUserId(userId: string): Room | undefined {
        return this.getRoom(room => room.users.some(user => user == userId));
    }
    
    
    getRoomById(roomId: string): Room | undefined {
        return this.getRoom(room => room.id == roomId);
    }
    
    private getRoom(callback: (room: Room) => boolean): Room | undefined {
        let returnRoom: Room | undefined = undefined;
        this.rooms.some(room => {
            if(callback(room)) {
                returnRoom = room;
                return true;
            }
            return false;
        })
        return returnRoom;
    }
}