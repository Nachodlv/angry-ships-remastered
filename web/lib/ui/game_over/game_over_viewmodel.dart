import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/global.dart';
import 'package:web/models/auth.dart';
import 'package:web/models/websocket/game_over_response.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:web/services/websockets/room_ws_service.dart';
import 'package:web/ui/home/home_view.dart';
import 'package:web/ui/room/room_view.dart';

class GameOverViewModel extends ChangeNotifier {
  final Socket socket;
  final String userId;
  final Credentials userCredentials;
  final GameOverResponse gameOverResponse;
  final NavigationService _navigationService = locator<NavigationService>();
  final RoomWsService _roomWsService = locator<RoomWsService>();

  StreamSubscription<String> _roomOpenedSub;
  
  bool get userWon => gameOverResponse.winnerId == userId;

  GameOverViewModel(
      {@required this.socket,
      @required this.userId,
      @required this.userCredentials,
      @required this.gameOverResponse});

  init() {
    if (socket == null ||
        userId == null ||
        userCredentials == null ||
        gameOverResponse == null) {
      SchedulerBinding.instance.addPostFrameCallback(
          (_) => _navigationService.navigateTo(Routes.LOAD));
      return;
    }

    _roomOpenedSub = _roomWsService.onRoomOpened.listen((roomId) =>
        _navigationService.navigateTo(Routes.ROOM,
            arguments: RoomViewArguments(
                socket: socket,
                id: roomId,
                userCredentials: userCredentials,
                userId: userId)));
  }

  rematch() {
    _navigationService.navigateTo(Routes.HOME,
        arguments: HomeViewArguments(
            userCredentials: userCredentials,
            userId: userId,
            socket: socket,
            rematchOpponentId: userWon
                ? gameOverResponse.loserId
                : gameOverResponse.winnerId));
  }

  goHome() {
    _navigationService.navigateTo(Routes.HOME,
        arguments: HomeViewArguments(
            userCredentials: userCredentials, userId: userId, socket: socket));
  }
  
  @override
  void dispose() {
    _roomOpenedSub.cancel();
    super.dispose();
  }
}
