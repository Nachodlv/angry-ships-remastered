import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/data_structures/remote_data.dart';
import 'package:web/global.dart';
import 'package:web/models/auth.dart';
import 'package:web/services/auth/auth_service.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:web/services/user/user_service.dart';
import 'package:web/services/websockets/boat_placement_ws_service.dart';
import 'package:web/services/websockets/chat_ws_service.dart';
import 'package:web/services/websockets/room_invite_ws_service.dart';
import 'package:web/services/websockets/room_ws_service.dart';
import 'package:web/services/websockets/shoot_ws_service.dart';
import 'package:web/services/websockets/socket_manager.dart';
import 'package:web/ui/room/room_view.dart';
import 'package:flutter/scheduler.dart';

class HomeViewModel extends ChangeNotifier {
  final Credentials credentials;
  final String userId;
  final String rematchOpponentId;
  final TextEditingController textInputController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  HomeViewModel(
      {@required this.credentials,
      @required this.userId,
      this.socket,
      this.rematchOpponentId});

  Socket socket;

  StreamSubscription<String> _onRoomOpenedSub;
  StreamSubscription<String> _onErrorSub;
  StreamSubscription<void> _onRoomClosedSub;

  NavigationService _navigationService = locator<NavigationService>();
  RoomWsService _roomWsService = locator<RoomWsService>();
  SocketManager _socketManager = locator<SocketManager>();
  UserService _userService = locator<UserService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  RemoteData<String, Unit> roomData = RemoteData.notAsked();
  RemoteData<String, String> userNameData = RemoteData.notAsked();

  init() async {
    if (this.credentials == null || this.userId == null) {
      print('No credentials!');
      SchedulerBinding.instance.addPostFrameCallback(
          (_) => _navigationService.navigateTo(Routes.LOAD));
      return;
    }
    _subscribeToSocket().then((_) {
      if (rematchOpponentId != null) _rematch();
    });

    _userService.getUser(userId, credentials.token).then((user) {
      userNameData = RemoteData.success(user.name);
      notifyListeners();
    }).catchError(() {
      userNameData = RemoteData.error('Couldn\'t retrieve the user');
      notifyListeners();
    });
    _onRoomOpenedSub = _roomWsService.onRoomOpened.listen((roomId) {
      _setRoomData(RemoteData.success(unit));
      _navigationService.navigateTo(Routes.ROOM,
          arguments: RoomViewArguments(
              socket: socket,
              id: roomId,
              userCredentials: this.credentials,
              userId: this.userId));
    });

    _onRoomClosedSub = _roomWsService.onRoomClosed.listen((_) {
      _setRoomData(RemoteData.notAsked());
    });

    _onErrorSub = _socketManager.onError.listen((errorMsg) {
      _setRoomData(RemoteData.error(errorMsg));
    });
  }

  play() {
    _setRoomData(RemoteData.loading());
    _roomWsService.findRoom(socket).then((response) {
      if (!response.startFinding)
        _setRoomData(RemoteData.error(response.message));
    });
  }

  signOut() {
    try {
      _setRoomData(RemoteData.loading());
      _authenticationService
          .signOut()
          .then((_) => _navigationService.navigateTo(Routes.LOGIN))
          .catchError(
              () => _setRoomData(RemoteData.error("Couldn't sign out")));
    } catch (e) {
      print(e);
    }
  }

  cancelFindRoom() {
    _setRoomData(RemoteData.notAsked());
    _roomWsService.cancelFindRoom(socket);
  }

  inviteUserByEmail() {
    final input = textInputController.text;
    if (input.isEmpty) return;
    _setRoomData(RemoteData.loading());
    _roomWsService
        .findRoom(socket, private: true, opponentEmail: input)
        .then((value) {
      if(!value.startFinding) _setRoomData(RemoteData.error(value.message));
      else textInputController.clear();
    });
  }

  _setRoomData(RemoteData<String, Unit> data) {
    roomData = data;
    notifyListeners();
  }

  Future<void> _subscribeToSocket() async {
    if (socket != null) return;
    socket = await _socketManager.connect(credentials.token);
    locator<ChatWsService>().subscribe(socket);
    locator<RoomWsService>().subscribe(socket);
    locator<ShootWsService>().subscribe(socket);
    locator<BoatPlacementWsService>().subscribe(socket);
    locator<RoomInviteWsService>().subscribe(socket);

    notifyListeners();
    return;
  }

  _rematch() {
    _setRoomData(RemoteData.loading());
    _roomWsService.findPrivateRoom(socket, rematchOpponentId).then((response) {
      if (!response.startFinding)
        _setRoomData(RemoteData.error(response.message));
    });
  }

  @override
  void dispose() {
    _onRoomOpenedSub.cancel();
    _onErrorSub.cancel();
    _onRoomClosedSub.cancel();
    super.dispose();
  }
}
