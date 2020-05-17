import {RoomProvider} from "../provider/room-provider";
import {app} from "../server/server";

export class RoomController {
    
    roomProvider: RoomProvider;
    url: string = "/room";
    
    constructor(roomProvider: RoomProvider) {
        this.roomProvider = roomProvider;
    }
    
    init() {
        this.getRoom();
    }
    
    getRoom() {
        app.get(`${this.url}/:id`, (req, res) => {
            const id = req.params.id;

            const room = this.roomProvider.getRoomById(id);
            if(room) {
                return res.status(200).send(room)
            } else {
                return res.status(404).send({message: 'Room not found'})
            }
        });
    }
}