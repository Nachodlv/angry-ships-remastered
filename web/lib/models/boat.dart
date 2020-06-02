import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web/models/point.dart';

part 'boat.freezed.dart';

@freezed
abstract class Boat with _$Boat {

  factory Boat(
    BoatID id,
    {int shoots,
    int rotationIndex,
    bool sunken,
    Point pivot,
    List<Point> points,
    BoatType boatType}) = _Boat;

  factory Boat.fromJson(Map<String, dynamic> json) {
    return Boat(
      BoatID(json['id']),
      shoots: json['shoots'],
      rotationIndex: json['rotationIndex'],
      sunken: json['sunken'],
      pivot: Point.fromJson(json['pivot']),
      points:
          List<dynamic>.from(json['points']).map((p) => Point.fromJson(p)).toList(),
      boatType: BoatType.values[json['boatType']]);
  }
  
  Map<String, dynamic> toJson() => {
    'shoots': shoots,
    'rotationIndex': rotationIndex,
    'sunken': sunken,
    'pivot': pivot.toJson(),
    'points': points.map((e) => e.toJson()).toList(),
    'boatType': boatType.index
  };
    
}

@freezed
abstract class BoatID with _$BoatID {
  factory BoatID(String id) = _BoatID;
}

enum BoatType { SMALL, NORMAL, BIG, EXTRA_BIG }
