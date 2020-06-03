﻿import {Boat} from "./boat";
import {BoatChecker} from "./board-checker";
import {Point} from "./point";

export class UserBoard {
    static MAX_ROWS = 10;
    static MAX_COLUMNS = 10;

    public boats: Boat[] = [];
    public shoots: Point[] = [];
    public state: UserBoardState = UserBoardState.PLACING_BOATS;

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

    private tryToPlaceBoat(boat: Boat): boolean {
        if (this.isBoatPlacementCorrect(boat) &&
            this.arePointsNeighbours(boat.points)) {
            this.boats.push(boat);
            return true;
        }
        return false;
    }

    addShoot(point: Point): ShootResult {

        if (this.isPointOutsideBoard(point)) return new ShootResult(false);
        for (const shoot of this.shoots) if (point.equals(shoot)) return new ShootResult(false);

        this.shoots.push(point);
        for (const boat of this.boats) {
            if (UserBoard.isBoatShoot(boat, point))
                return new ShootResult(true, boat);
        }
        return new ShootResult(true);
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

    public isPointOverlappingAnotherShip(boatPoint: Point): boolean {
        for (let boatPlaced of this.boats) {
            for (let point of boatPlaced.getGlobalPoints()) {
                if (boatPoint.equals(point)) return true;
            }
        }
        return false;
    }

    public isPointOutsideBoard(point: Point): boolean {
        return point.column < 0 || point.column >= UserBoard.MAX_COLUMNS ||
            point.row < 0 || point.row >= UserBoard.MAX_ROWS
    }
}

export class ShootResult {
    constructor(public isValid: boolean, public boatShoot: Boat | undefined = undefined) {
    }

    toString(): string {
        return `Is valid: ${this.isValid}, boatShoot: ${this.boatShoot}`
    }
}

export enum UserBoardState {
    PLACING_BOATS,
    READY
}
