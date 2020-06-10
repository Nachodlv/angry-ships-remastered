import {Boat} from "./boat";
import {BoatChecker} from "./board-checker";
import {Point} from "./point";

export class UserBoard {
    static MAX_ROWS = 10;
    static MAX_COLUMNS = 10;

    public boats: Boat[] = [];
    public shoots: Point[] = [];
    public state: UserBoardState = UserBoardState.PLACING_BOATS;
    public turnTimeout: NodeJS.Timeout | undefined = undefined;

    constructor(
        public userId: string,
        public roomId: string) {
    }

    placeBoats(boats: Boat[], allBoats: boolean): Boat[] {
        if (!BoatChecker.areBoatTypesValid(boats, allBoats)) return boats;
        const boatsNotPlaced: Boat[] = [];
        boats.forEach(boat => {
            if (!this.tryToPlaceBoat(boat)) boatsNotPlaced.push(boat);
        })
        return boatsNotPlaced;
    }
    
    addRandomShoot(): ShootResult {
        const row =  Math.floor(Math.random() * UserBoard.MAX_ROWS);
        const column =  Math.floor(Math.random() * UserBoard.MAX_COLUMNS);
        const point = new Point(row, column);
        if(this.isShootOverlapping(point)) return this.addRandomShoot();
        return this.addValidShoot(point);
    }

    addShoot(point: Point): ShootResult {
        if (this.isPointOutsideBoard(point)) return new ShootResult(false, point);
        if(this.isShootOverlapping(point)) return new ShootResult(false, point);
        return this.addValidShoot(point);
    }

    isPointOverlappingAnotherShip(boatPoint: Point): boolean {
        for (let boatPlaced of this.boats) {
            for (let point of boatPlaced.getGlobalPoints()) {
                if (boatPoint.equals(point)) return true;
            }
        }
        return false;
    }

    isPointOutsideBoard(point: Point): boolean {
        return point.column < 0 || point.column >= UserBoard.MAX_COLUMNS ||
            point.row < 0 || point.row >= UserBoard.MAX_ROWS
    }

    areAllBoatsSunken(): boolean {
        return this.boats.every(boat => boat.sunken)
    }

    private addValidShoot(point: Point): ShootResult {
        this.shoots.push(point);
        for (const boat of this.boats) {
            if (UserBoard.isBoatShoot(boat, point))
                return new ShootResult(true, point, true, boat.sunken ? boat : undefined);
        }
        return new ShootResult(true, point);
    }

    private tryToPlaceBoat(boat: Boat): boolean {
        if (this.isBoatPlacementCorrect(boat) &&
            this.arePointsNeighbours(boat.points)) {
            this.boats.push(boat);
            return true;
        }
        return false;
    }

    private static isBoatShoot(boat: Boat, point: Point): boolean {
        for (const boatPoints of boat.getGlobalPoints()) {
            if (point.equals(boatPoints)) {
                boat.addShoot();
                return true;
            }
        }
        return false;
    }

    private isBoatPlacementCorrect(boat: Boat): boolean {
        for (const boatPoints of boat.getGlobalPoints()) {
            if (this.isPointOutsideBoard(boatPoints)) return false;
            if (this.isPointOverlappingAnotherShip(boatPoints)) return false;
        }
        return true;
    }

    private arePointsNeighbours(points: Point[]) {
        for (let i = 1; i < points.length; i++) {
            if (!points[i].isNeighbour(points[i - 1])) return false;
        }
        return true;
    }

    private isShootOverlapping(point: Point): boolean {
        for (const shoot of this.shoots) 
            if (point.equals(shoot)) return true;
        return false;
    }
    
}

export class ShootResult {
    constructor(public isValid: boolean, public point: Point, public boatShoot: boolean = false, 
                public boatSunken: Boat | undefined = undefined) {
    }

    toString(): string {
        return `Is valid: ${this.isValid}, boatShoot: ${this.boatShoot}`
    }
}

export enum UserBoardState {
    PLACING_BOATS,
    READY
}
