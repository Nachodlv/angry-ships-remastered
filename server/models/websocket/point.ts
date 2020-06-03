export class Point {
    constructor(public row: number, public column: number) {
    }

    equals(point: Point): boolean {
        return this.row == point.row && this.column == point.column;
    }
    
    isNeighbour(point: Point) : boolean {
        const rowDifference = Math.pow(this.row - point.row, 2);
        const columnDifference = Math.pow(this.column - point.column, 2);
        return Math.pow(rowDifference + columnDifference, 1/2) <= 1;
    }
    
    toString(): string {
        return `(${this.row}, ${this.column})`
    }
    
    static fromJson(json: any): Point {
        return new Point(json.row, json.column);
    }

    add(point: Point): Point {
        return new Point(point.row + this.row, point.column + this.column);
    }
}

