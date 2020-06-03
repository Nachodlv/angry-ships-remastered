import {Message} from "./message";

export class Room {
    static MAXIMUM_USERS: number = 2;
    static SECONDS_PER_TURN: number = 60000;
    
    public currentTurn: number = 0;
    
    constructor(
        public id: string,
        public users: UserInRoom[],
        public messages: Message[] = [],
        public started = false,
        public roomState: RoomState = RoomState.PLACING_BOATS) {
    }
    
    isFull(): boolean {
        return this.users.length >= Room.MAXIMUM_USERS;
    }
}

export class UserInRoom {
    constructor(public userId: string, public socketId: string) {
    }
}

export enum RoomState {
    PLACING_BOATS,
    PLAYING,
    ENDING
}

