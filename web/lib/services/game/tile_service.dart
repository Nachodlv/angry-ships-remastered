import 'package:extended_math/extended_math.dart';
import 'package:web/models/point.dart';

class TileService {
  static final _clockwiseRotationMatrix =
    Matrix(<List<int>>[
      <int>[0, -1],
      <int>[1, 0]
    ]);

    static final _counterClockwiseRotationMatrix =
    Matrix(<List<int>>[
      <int>[0, 1],
      <int>[-1, 0]
    ]);

  static Point rotatePoint(Point pivot, Point pointToRotate, bool rotateClockwise) {
    Point relativePoint = pointToRotate - pivot;

    Matrix rotationMatrix = rotateClockwise
      ? _clockwiseRotationMatrix
      : _counterClockwiseRotationMatrix;

    final relativeRotatedPoint = _rotate(rotationMatrix, relativePoint.asVector);
    
    return relativeRotatedPoint + pivot;
  }
    
  static _rotate(Matrix rotationMatrix, Vector relativePoint) => Point(
    rotationMatrix.columnAsVector(0).dot(relativePoint),
    rotationMatrix.columnAsVector(1).dot(relativePoint)
  );
}

extension PointMath on Point {
  operator -(Point point) {
    return Point(
      this.row - point.row,
      this.column - point.column
    );
  }

  operator +(Point point) {
    return Point(
      this.row + point.row,
      this.column + point.column
    );
  }

  Vector get asVector => Vector(
    <int>[
      this.row,
      this.column
    ]
  );
}