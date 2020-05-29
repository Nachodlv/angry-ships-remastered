import {Message} from "./message";

export class Room {
    static MAXIMUM_USERS: number = 2;
    public currentTurn: number = 0;
    constructor(
        public id: string,
        public users: string[],
        public messages: Message[] = [],
        public started = false,
        public roomState: RoomState = RoomState.PLACING_BOATS) {
    }
    
    isFull(): boolean {
        return this.users.length >= Room.MAXIMUM_USERS;
    }
}

export enum RoomState {
    PLACING_BOATS,
    PLAYING,
    ENDING
}

