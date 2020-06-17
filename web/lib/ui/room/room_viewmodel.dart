import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/global.dart';
import 'package:web/models/auth.dart';
import 'package:web/models/boat.dart';
import 'package:web/models/message.dart';
import 'package:web/models/room.dart';
import 'package:web/models/websocket/game_over_response.dart';
import 'package:web/models/websocket/room_ready_response.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/room/room_service.dart';
import 'package:web/services/user/user_service.dart';
import 'package:web/services/websockets/chat_ws_service.dart';
import 'package:web/services/websockets/room_ws_service.dart';
import 'package:web/services/websockets/socket_manager.dart';
import 'package:web/ui/game_over/game_over_view.dart';
import 'package:web/ui/home/home_view.dart';

class RoomViewModel extends ChangeNotifier {
  final String roomId;
  final Credentials credentials;
  final String userId;

  User user;
  User opponent;
  Socket socket;
  Room room;
  bool boatsPlaced = false;
  bool firstTurn = false;
  List<Boat> boats = new List();

  StreamSubscription<void> onRoomClosedSub;
  StreamSubscription<String> onErrorSocketSub;
  StreamSubscription<RoomReadyResponse> onRoomReadySub;
  StreamSubscription<GameOverResponse> onGameOverSub;

  final NavigationService _navigationService = locator<NavigationService>();
  final RoomService _roomService = locator<RoomService>();
  final UserService _userService = locator<UserService>();
  final RoomWsService _roomWsService = locator<RoomWsService>();
  final SocketManager _socketManager = locator<SocketManager>();

  RoomViewModel({this.socket, this.roomId, this.credentials, this.userId});

  init() async {
    if (credentials == null || userId == null) {
      SchedulerBinding.instance.addPostFrameCallback(
          (_) => _navigationService.navigateTo(Routes.LOAD));
      return;
    } else if (socket == null || roomId == null) {
      _navigationService.navigateTo(Routes.HOME,
          arguments:
              HomeViewArguments(userCredentials: credentials, userId: userId));
      return;
    }

    onRoomClosedSub = _roomWsService.onRoomClosed.listen((_) async {
      _navigationService.navigateTo(Routes.HOME,
          arguments:
              HomeViewArguments(userCredentials: credentials, userId: userId, socket: socket));
    });

    onErrorSocketSub = _socketManager.onError.listen((errorMsg) {
      print('Oops! $errorMsg');
    });

    room = await _roomService.getRoomById(roomId, credentials.token);

    user = await _userService.getUser(userId, credentials.token);
    final opponentId = room.users.firstWhere((id) => id != userId);
    opponent = await _userService.getUser(opponentId, credentials.token);

    onRoomReadySub = _roomWsService.onRoomReady.listen((roomReady) {
      boatsPlaced = true;
      firstTurn = roomReady.firstUser == userId;
      notifyListeners();
    });

    onGameOverSub = _roomWsService.onGameOver.listen((response) {
      _navigationService.navigateTo(Routes.GAME_OVER,
          arguments: GameOverArguments(
              socket: socket,
              userCredentials: credentials,
              userId: userId,
              gameOverResponse: response));
    });
    notifyListeners();
  }


  finishPlacingBoats(List<Boat> boats) {
    this.boats = boats;
    notifyListeners();
  }

  @override
  void dispose() {
    onRoomClosedSub.cancel();
    onErrorSocketSub.cancel();
    onRoomReadySub.cancel();
    onGameOverSub.cancel();
    super.dispose();
  }
}
