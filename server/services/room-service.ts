import {Room} from "../models/websocket/room";

const { v4: uuidv4 } = require('uuid');

export class RoomService{
    rooms: Room[] = [];
    
    getAvailableRoom(): Room | undefined {
        let availableRoom: Room | undefined = undefined;
        this.rooms.some((room) => {
            if(!room.isFull()) {
                availableRoom = room;
                return true;
            }
            return false;
        });
        return availableRoom;
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
        let returnRoom: Room | undefined = undefined;
        this.rooms.some(room => {
            if(room.users.some(user => user == userId)) {
                returnRoom = room;
                return true;
            }
            return false;
        })
        return returnRoom;
    }
}