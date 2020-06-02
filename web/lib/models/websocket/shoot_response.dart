import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:web/models/boat.dart';

class ShootResponse {
//  public isValid: boolean, public boatShoot: Boat | undefined = undefined

  final bool isValid;
  final Option<Boat> boatShoot;

  ShootResponse({@required this.isValid, this.boatShoot});

  factory ShootResponse.fromJson(Map<String, dynamic> json) {
    final boatShoot = json['boatShoot'];
    return ShootResponse(
        isValid: json['isValid'],
        boatShoot: boatShoot != null ? Some(Boat.fromJson(boatShoot)) : None());
  }
}
