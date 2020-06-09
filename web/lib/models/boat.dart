import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web/models/point.dart';


class Boat {

  final String id;
  final int shoots;
  int rotationIndex;
  Point pivot;
  final bool sunken;
  final List<Point> points;
  final BoatType boatType;

  Boat({
    @required this.id,
    this.pivot,
    this.boatType,
    this.rotationIndex = 0,
    this.shoots = 0,
    this.sunken = false,
    this.points = const [],
  });

  factory Boat.fromJson(Map<String, dynamic> json) {
    return Boat(
        id: json['id'],
        shoots: json['shoots'],
        rotationIndex: json['rotationIndex'],
        sunken: json['sunken'],
        pivot: Point.fromJson(json['pivot']),
        points:
        List<dynamic>.from(json['points'])
            .map((p) => Point.fromJson(p))
            .toList(),
        boatType: BoatType.values[json['boatType']]);
  }

//  factory Boat.fromJson(Map<String, dynamic> json) => _$BoatFromJson(json);

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'shoots': shoots,
        'rotationIndex': rotationIndex,
        'sunken': sunken,
        'pivot': pivot.toJson(),
        'points': points.map((e) => e.toJson()).toList(),
        'boatType': boatType.index
      };
  
  List<Point> globalPoints({Point point})  {
    final pointParam = point ?? pivot;
    if(rotationIndex == 0) return points.map((p) => p + pointParam).toList();
    else return points.map((p) => Point(pointParam.row + p.column, pointParam.column + p.row)).toList();
  }
}
enum BoatType { SMALL, NORMAL, BIG, EXTRA_BIG }
