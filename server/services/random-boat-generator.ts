import {UserBoard} from "../models/websocket/user-board";
import {Boat} from "../models/websocket/boat";
import {BoatChecker} from "../models/websocket/board-checker";
import {Point} from "../models/websocket/point";

export class RandomBoatGenerator {
    
    public assignRandomBoats(userBoard: UserBoard){
        for (let boatType of BoatChecker.quantitiesOfBoatType) {
            const boatsPlaced = userBoard.boats.filter(boat => boat.boatType == boatType[0]).length;
            for (let i = 0; i < boatType[1].quantity - boatsPlaced; i++) {
                let neighbours: Point[] = [];
                let rotation = 0;
                let point: Point = new Point(0, 0);
                while(neighbours.length == 0) {
                    point = this.getValidRandomPoint(userBoard);
                    const result = this.getValidNeighbourPoints(point, boatType[1].height - 1, userBoard);
                    neighbours = result.points;
                    rotation = result.rotationIndex;
                }
                userBoard.boats.push(new Boat(this.randomRange(0, 100000).toString(), point, neighbours, rotation, boatType[0]))
            }
            
        }
    }

    getValidRandomPoint(userBoard: UserBoard): Point {
        const row = this.randomRange(0, UserBoard.MAX_ROWS);
        const column = this.randomRange(0, UserBoard.MAX_COLUMNS);
        const point = new Point(row, column);
        if(userBoard.isPointOverlappingAnotherShip(point)) return this.getValidRandomPoint(userBoard);
        return point;
    }

    getValidNeighbourPoints(point: Point, quantity: number, userBoard: UserBoard): {points: Point[], rotationIndex: number} {
        const rotations = [0, 1];
        rotations.sort(() => Math.random() - 0.5);
        let points: Point[] = [];
        for (let rotation of rotations) {
            points = this.generatePoints(point, quantity, userBoard, rotation);
            if(points.length > 0) return {points: points, rotationIndex: rotation};
        }
        return {points: [], rotationIndex: 0};
    }

    generatePoints(pivot: Point, quantity: number, userBoard: UserBoard, rotation: number): Point[] {
        let points: Point[] = [];
        for(let i = 0; i <= quantity; i++) {
            const newPoint: Point = new Point(i,0);
            let globalPoint: Point;
            if(rotation == 0) {
                globalPoint = newPoint.add(pivot);
            } else {
                globalPoint = new Point(pivot.row + newPoint.column, pivot.column + newPoint.row);
            }
            if(userBoard.isPointOutsideBoard(globalPoint) || userBoard.isPointOverlappingAnotherShip(globalPoint)) {
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