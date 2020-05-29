import 'package:web/models/point.dart';

import 'models/boat.dart';

List<Boat> getBoats() {
  return [
    Boat(
        pivot: Point(0, 0),
        points: [Point(0, 0), Point(0, 1)],
        boatType: BoatType.SMALL),
    Boat(
        pivot: Point(1, 0),
        points: [Point(1, 0), Point(1, 1)],
        boatType: BoatType.SMALL),
    Boat(
        pivot: Point(2, 0),
        points: [Point(2, 0), Point(2, 1)],
        boatType: BoatType.SMALL),
    Boat(
        pivot: Point(0, 2),
        points: [Point(0, 2), Point(0, 3), Point(0,4)],
        boatType: BoatType.NORMAL),
    Boat(
        pivot: Point(1, 2),
        points: [Point(1, 2), Point(1, 3), Point(1,4)],
        boatType: BoatType.NORMAL),
    Boat(
        pivot: Point(3, 0),
        points: [Point(3, 0), Point(4, 0), Point(5, 0), Point(6, 0)],
        boatType: BoatType.BIG),
    Boat(
        pivot: Point(3, 1),
        points: [Point(3, 1), Point(4, 1), Point(5, 1), Point(6, 1), Point(7, 1)],
        boatType: BoatType.EXTRA_BIG),
  ];
}