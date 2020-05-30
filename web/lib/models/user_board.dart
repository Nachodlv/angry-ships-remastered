import 'package:flutter/material.dart';
import 'package:web/models/boat.dart';
import 'package:web/models/point.dart';

class UserBoard {
  final List<Boat> boats;
  final List<Point> shoots;

  UserBoard({@required this.boats, @required this.shoots});
}