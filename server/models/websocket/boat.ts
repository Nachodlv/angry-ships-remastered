import {Point} from "./point";

export class Boat {
    private shoots: number = 0;
    public sunken: boolean = false;

    constructor(public pivot: Point,
                public points: Point[],
                // public rotation: number, 
                public boatType: BoatType
    ) {
    }

    addShoot() {
        this.shoots ++;
        this.sunken = this.shoots >= this.points.length;
    }
}

export enum BoatType {
    AIRPORT,
    BIG,
    NORMAL,
    SMALL,
}