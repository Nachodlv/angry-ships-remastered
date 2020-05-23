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

    static fromJson(json: any): Boat {
        return new Boat(json.pivot, json.points.map((point: any) => new Point(point.row, point.column)), json.boatType);
    }
    
    addShoot() {
        this.shoots++;
        this.sunken = this.shoots >= this.points.length;
    }
}

export enum BoatType {
    EXTRA_BIG,
    BIG,
    NORMAL,
    SMALL,
}