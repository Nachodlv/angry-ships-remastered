class Point {
  final int row;
  final int column;

  Point(this.row, this.column);

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(json['row'], json['column']);
  }

  Map<String, dynamic> toJson() =>
      {
        'row': row,
        'column': column
      };
  Point operator + (Point point) {
    return Point(row + point.row, column + point.column);
  }
  
  bool operator ==(dynamic point) {
    if(!(point is Point)) return false;
    return row == point.row && column == point.column;
  }

  @override
  int get hashCode => super.hashCode;

}
