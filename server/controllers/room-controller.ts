import {app} from "../server/server";
import {RoomService} from "../services/room-service";

export class RoomController {
    
    roomService: RoomService;
    url: string = "/room";
    
    constructor(roomProvider: RoomService) {
        this.roomService = roomProvider;
    }
    
    init() {
        this.getRoom();
    }
    
    getRoom() {
        app.get(`${this.url}/:id`, (req, res) => {
            const id = req.params.id;

            const room = this.roomService.getRoomById(id);
            if(room) {
                return res.status(200).send(room)
            } else {
                return res.status(404).send({message: 'Room not found'})
            }
        });
    }
}