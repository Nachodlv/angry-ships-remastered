import {Point} from "./point";
import {Boat} from "./boat";
import {BoatChecker} from "./room";

class UserBoard { //TODO create when room is created
    static MAX_ROWS = 10;
    static MAX_COLUMNS = 10;

    constructor(
        public shoots: Point[],
        public boats: Boat[],
        public userId: string,
        public roomId: string) {
    }

    placeBoat(boat: Boat): boolean { // TODO check if the points are continuous, place all boats at the same time, check overlapping
        if (BoatChecker.isBoardValid([...this.boats, boat]) && this.isBoatInsideBoard(boat)) {
            this.boats.push(boat);
            return true;
        }
        return false;
    }

    // TODO check if the point is already shoot
    addShoot(point: Point): Boat | undefined {
        this.shoots.push(point);
        for (const boat of this.boats) {
            if (UserBoard.isBoatShoot(boat, point))
                return boat;
        }
        return undefined;
    }

    private static isBoatShoot(boat: Boat, point: Point): boolean {
        for (const boatPoints of boat.points) {
            if (point.equals(boatPoints)) {
                boat.addShoot();
                return true;
            }
        }
        return false;
    }

    private isBoatInsideBoard(boat: Boat): boolean {
        for (const boatPoints of boat.points) {
            if (boatPoints.column < 0 || boatPoints.column >= UserBoard.MAX_COLUMNS ||
                boatPoints.row < 0 || boatPoints.row >= UserBoard.MAX_ROWS) return false;
        }
        return true;
    }
}
