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
}
