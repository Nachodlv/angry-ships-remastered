export class Point {
    constructor(public row: number, public column: number) {
    }

    equals(point: Point): boolean {
        return this.row == point.row && this.column == point.column;
    }
}

