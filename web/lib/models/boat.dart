import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web/models/point.dart';


class Boat {

  final String id;
  final int shoots;
  final int rotationIndex;
  final bool sunken;
  final Point pivot;
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

  Boat copyWith({
    String id,
    int rotationIndex,
    Point pivot,
    BoatType boatType,
    List<Point> shoots,
    bool sunken,
    List<Point> points,
  }) {
    return Boat(id: id ?? this.id,
        rotationIndex: rotationIndex ?? this.rotationIndex,
        pivot: pivot ?? this.pivot,
        boatType: boatType ?? this.boatType,
        shoots: shoots ?? this.shoots,
        sunken: sunken ?? this.sunken,
        points: points ?? this.points);
  }

}
enum BoatType { SMALL, NORMAL, BIG, EXTRA_BIG }
