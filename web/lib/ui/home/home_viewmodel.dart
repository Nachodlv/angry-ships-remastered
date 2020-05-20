import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/data_structures/remote_data.dart';
import 'package:web/global.dart';
import 'package:web/models/auth.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:web/services/websockets/room_ws_service.dart';
import 'package:web/services/websockets/socket_manager.dart';
import 'package:web/ui/room/room_view.dart';

class HomeViewModel extends ChangeNotifier {
  final Credentials credentials;
  final String userId;

  HomeViewModel(this.credentials, this.userId);

  Socket socket;

  NavigationService _navigationService = locator<NavigationService>();
  RoomWsService _roomWsService = locator<RoomWsService>();
  SocketManager _socketManager = locator<SocketManager>();
  RemoteData<String, Unit> roomData = RemoteData.notAsked();

  init() async {
    socket = await _socketManager.connect(credentials.token);

    _roomWsService.onRoomOpened.listen(
      (roomId) {
        _setRoomData(RemoteData.success(unit));
        _navigationService.navigateTo(Routes.ROOM, arguments: RoomViewArguments(socket, roomId, this.credentials, this.userId));
      }
    );

    _socketManager.onError.listen((errorMsg) {
      _setRoomData(RemoteData.error(errorMsg));
      print('Oops! $errorMsg');
    });
  }

  play() {
    _setRoomData(RemoteData.loading());
    _roomWsService.findRoom(socket);
  }

  _setRoomData(RemoteData<String, Unit> data) {
    roomData = data;
    notifyListeners();
  }
}