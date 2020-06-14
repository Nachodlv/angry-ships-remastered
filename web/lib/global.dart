import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:web/services/auth/auth_service.dart';
import 'package:web/services/auth/auth_service_firebase.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:web/services/room/room_service.dart';
import 'package:web/services/user/user_service.dart';
import 'package:web/services/websockets/boat_placement_ws_service.dart';
import 'package:web/services/websockets/chat_ws_service.dart';
import 'package:web/services/websockets/room_invite_ws_service.dart';
import 'package:web/services/websockets/room_ws_service.dart';
import 'package:web/services/websockets/shoot_ws_service.dart';
import 'package:web/services/websockets/socket_manager.dart';

final locator = GetIt.instance;

Future<Unit> setupLocator(BuildContext context) async {
  final url = 'http://localhost:3000';
  final json = jsonDecode(await DefaultAssetBundle.of(context).loadString('assets/credentials/firebase-credentials.json'));
  final app = await FirebaseApp.configure(
      name: "Angry Ships",
      options: FirebaseOptions(
        googleAppID: json['googleAppID'],
        apiKey: json['apiKey'],
        projectID: json['projectID'],
        storageBucket: "project-id.appspot.com",
      ));
  
  locator.registerSingleton<AuthenticationService>(AuthenticationServiceFirebase(app));
  locator.registerSingleton<NavigationService>(NavigationService());
  locator.registerSingleton<SocketManager>(SocketManager(url));
  locator.registerSingleton<RoomService>(RoomService(url));
  locator.registerSingleton<UserService>(UserService(url));
  
  locator.registerSingleton<ChatWsService>(ChatWsService()); 
  locator.registerSingleton<RoomWsService>(RoomWsService());
  locator.registerSingleton<BoatPlacementWsService>(BoatPlacementWsService());
  locator.registerSingleton<ShootWsService>(ShootWsService());
  locator.registerSingleton<RoomInviteWsService>(RoomInviteWsService());
  
  return unit;
}

const int kTilesPerRow = 10;
const int kTilesQuantity = kTilesPerRow * kTilesPerRow;
