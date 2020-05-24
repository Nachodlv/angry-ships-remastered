import 'package:flutter/material.dart';
import 'package:web/models/point.dart';

class Boat {
  final int shoots;
  final bool sunken;
  final Point pivot;
  final List<Point> points;
  final BoatType boatType;

  Boat(
      {this.shoots = 0,
      this.sunken = false,
      @required this.pivot,
      @required this.points,
      @required this.boatType});

  factory Boat.fromJson(Map<String, dynamic> json) {
    return Boat(
        shoots: json['shoots'],
        sunken: json['sunken'],
        pivot: Point.fromJson(json['pivot']),
        points:
            List<dynamic>.from(json['points']).map((p) => Point.fromJson(p)).toList(),
        boatType: BoatType.values[json['boatType']]);
  }
  
  Map toJson() => {
    'shoots': shoots,
    'sunken': sunken,
    'pivot': pivot.toJson(),
    'points': points.map((e) => e.toJson()).toList(),
    'boatType': boatType.index
  };
    
}

enum BoatType { EXTRA_BIG, BIG, NORMAL, SMALL }
