import {Message} from "./message";
import {Boat, BoatType} from "./boat";

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

export class BoatChecker {
    private static quantitiesOfBoatType: Map<BoatType, number> = new Map<BoatType, number>([
        [BoatType.AIRPORT, 1],
        [BoatType.BIG, 1],
        [BoatType.NORMAL, 2],
        [BoatType.SMALL, 3]
    ])

    static isBoardValid(boats: Boat[]): boolean {
        for (const boatType of this.quantitiesOfBoatType) {
            let quantity = 0;
            for (const boat of boats) {
                if (boat.boatType == boatType[0]) quantity++;
            }
            if (quantity > boatType[1]) return false;
        }
        return true;
    }
}

