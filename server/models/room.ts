import {Message} from "./message";

export class Room {
    static MAXIMUM_USERS: number = 2;

    messages: Message[] = [];
    started: boolean = false;
    
    constructor(public id: string, public users: string[]) {
    }
    
    isFull(): boolean {
        return this.users.length >= Room.MAXIMUM_USERS;
    }
}