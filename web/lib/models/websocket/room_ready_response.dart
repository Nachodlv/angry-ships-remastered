import 'package:flutter/material.dart';

class RoomReadyResponse {
  final String firstUser;

  RoomReadyResponse({@required this.firstUser});

  factory RoomReadyResponse.fromJson(Map<String, dynamic> json) {
    return RoomReadyResponse(firstUser: json['firstUser']);
  }
}