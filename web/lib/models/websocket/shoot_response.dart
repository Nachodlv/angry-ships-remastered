import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:web/models/boat.dart';
import 'package:web/models/point.dart';

class ShootResponse {
//  public isValid: boolean, public boatShoot: Boat | undefined = undefined

  final bool isValid;
  final bool boatShoot;
  final Point point;
  final Option<Boat> boatSunken;

  ShootResponse({@required this.isValid, @required this.point, this.boatShoot, this.boatSunken});

  factory ShootResponse.fromJson(Map<String, dynamic> json) {
    final boatSunken = json['boatSunken'];
    return ShootResponse(
        isValid: json['isValid'],
        point: Point.fromJson(json['point']),
        boatShoot: json['boatShoot'],
        boatSunken:  boatSunken != null ? Some(Boat.fromJson(boatSunken)) : None());
  }
}
