import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/global.dart';
import 'package:web/models/auth.dart';
import 'package:web/models/message.dart';
import 'package:web/models/room.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/room/room_service.dart';
import 'package:web/services/websockets/chat_ws_service.dart';
import 'package:web/services/websockets/room_ws_service.dart';
import 'package:web/services/websockets/socket_manager.dart';


class RoomViewModel extends ChangeNotifier {
  final String roomId;
  final Credentials credentials;
  final String userId;

  Socket socket;
  Room room;
  StreamSubscription<void> onRoomClosedSub;
  StreamSubscription<String> onErrorSocketSub;
  StreamSubscription<Message> onMessageSub;
  List<Message> messages = [];

  NavigationService _navigationService = locator<NavigationService>();
  RoomService _roomService = locator<RoomService>();
  RoomWsService _roomWsService = locator<RoomWsService>();
  ChatWsService _chatWsService = locator<ChatWsService>();
  SocketManager _socketManager = locator<SocketManager>();


  RoomViewModel(this.roomId, this.credentials, this.userId);
  
  init() async {
    onRoomClosedSub = _roomWsService.onRoomClosed.listen(
      (_) {
        _navigationService.navigateTo(Routes.HOME);
      }
    );

    onErrorSocketSub = _socketManager.onError.listen((errorMsg) {
      print('Oops! $errorMsg');
    });

    room = await _roomService.getRoomById(roomId, credentials.token);
    messages = room.messages; // Initial messages; Is this info always duplicated? What's the purpose of this field in room?

    _chatWsService.startListeningToMessages(socket);

    onMessageSub = _chatWsService.onMessage.listen((message) {
      messages.add(message);
      notifyListeners();
    });
  }


}