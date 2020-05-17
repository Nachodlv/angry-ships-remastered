﻿import {Message} from "./message";

export class Room {
    static MAXIMUM_USERS: number = 2;
    
    constructor(
        public id: string, 
        public users: string[], 
        public messages: Message[] = [], 
        public started = false) {
    }
    
    isFull(): boolean {
        return this.users.length >= Room.MAXIMUM_USERS;
    }
}