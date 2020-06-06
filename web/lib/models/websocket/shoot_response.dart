import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:web/models/boat.dart';
import 'package:web/models/point.dart';

class ShootResponse {
//  public isValid: boolean, public boatShoot: Boat | undefined = undefined

  final bool isValid;
  final Option<Boat> boatShoot;
  final Point point;

  ShootResponse({@required this.isValid, @required this.point, this.boatShoot});

  factory ShootResponse.fromJson(Map<String, dynamic> json) {
    final boatShoot = json['boatShoot'];
    return ShootResponse(
        isValid: json['isValid'],
        point: Point.fromJson(json['point']),
        boatShoot: boatShoot != null ? Some(Boat.fromJson(boatShoot)) : None());
  }
}
