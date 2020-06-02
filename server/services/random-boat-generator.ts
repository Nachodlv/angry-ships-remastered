﻿import {UserBoard} from "../models/websocket/user-board";
import {Boat} from "../models/websocket/boat";
import {BoatChecker} from "../models/websocket/board-checker";
import {Point} from "../models/websocket/point";

export class RandomBoatGenerator {
    
    public getRandomBoats(userBoard: UserBoard): Boat[] {
        const boats: Boat[] = [];
        for (let boatType of BoatChecker.quantitiesOfBoatType) {
            const boatsPlaced = userBoard.boats.filter(boat => boat.boatType == boatType[0]).length;
            for (let i = 0; i < boatType[1].quantity - boatsPlaced; i++) {
                let neighbours: Point[] = [];
                let point: Point = new Point(0, 0);
                while(neighbours.length == 0) {
                    point = this.getValidRandomPoint(userBoard);
                    neighbours = this.getValidNeighbourPoints(point, boatType[1].height - 1, userBoard);
                }
                boats.push(new Boat(point, [point, ...neighbours], 0, boatType[0]))
            }
            
        }
        return boats;
    }

    getValidRandomPoint(userBoard: UserBoard): Point {
        const row = this.randomRange(0, UserBoard.MAX_ROWS);
        const column = this.randomRange(0, UserBoard.MAX_COLUMNS);
        const point = new Point(row, column);
        if(userBoard.isPointOverlappingAnotherShip(point)) return this.getValidRandomPoint(userBoard);
        return point;
    }

    getValidNeighbourPoints(point: Point, quantity: number, userBoard: UserBoard): Point[] {
        const rotations = [0, 1, 2, 3];
        rotations.sort(() => Math.random() - 0.5);
        let points: Point[] = [];
        for (let rotation of rotations) {
            points = this.generatePoints(point, quantity, userBoard, rotation);
            if(points.length > 0) return points;
        }
        return [];
    }

    generatePoints(point: Point, quantity: number, userBoard: UserBoard, rotation: number): Point[] {
        let points: Point[] = [];
        for(let i = 1; i <= quantity; i++) {
            let newPoint: Point = new Point(0,0);
            switch (rotation) {
                case 0:
                    newPoint = new Point(point.row - i, point.column);
                    break;
                case 1:
                    newPoint = new Point(point.row, point.column - i);
                    break;
                case 2:
                    newPoint = new Point(point.row + i, point.column);
                    break;
                case 3:
                    newPoint = new Point(point.row, point.column + i);
                    break;
            }
            if(!userBoard.isPointOutsideBoard(newPoint) || userBoard.isPointOverlappingAnotherShip(newPoint)) {
                return [];
            }
            points.push(newPoint);
        }
        return points;
    }

    randomRange(min: number, max: number): number {
        return Math.floor(Math.random() * (max - min)) + min;
    }
}