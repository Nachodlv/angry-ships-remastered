import {Point} from "./point";

export class Boat {
    private shoots: number = 0;
    public sunken: boolean = false;

    constructor(
        public id: string,
        public pivot: Point,
        public points: Point[],
        private rotationIndex: number = 0, // Restrict to 0, 1, 2 or 3
        // public rotation: number, 
        public boatType: BoatType
    ) {
    }

    static fromJson(json: any): Boat {
        return new Boat(
            json.id,
            json.pivot,
            json.points.map((point: any) => new Point(point.row, point.column)),
            json.rotationIndex,
            json.boatType);
    }

    addShoot() {
        this.shoots++;
        this.sunken = this.shoots >= this.points.length;
    }
    
    getGlobalPoints(): Point[] {
        if(this.rotationIndex == 0) return this.points.map(point => point.add(this.pivot));
        else return this.points.map(point => 
            new Point(this.pivot.row + point.column, this.pivot.column + point.row));
    }
}

export enum BoatType {
    SMALL,
    NORMAL,
    BIG,
    EXTRA_BIG,
}