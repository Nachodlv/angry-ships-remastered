import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/global.dart';
import 'package:web/models/auth.dart';
import 'package:web/models/message.dart';
import 'package:web/models/room.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/room/room_service.dart';
import 'package:web/services/user/user_service.dart';
import 'package:web/services/websockets/chat_ws_service.dart';
import 'package:web/services/websockets/room_ws_service.dart';
import 'package:web/services/websockets/socket_manager.dart';
import 'package:web/ui/home/home_view.dart';


class RoomViewModel extends ChangeNotifier {
  final String roomId;
  final Credentials credentials;
  final String userId;

  User user;
  User opponent;
  Socket socket;
  Room room;
  StreamSubscription<void> onRoomClosedSub;
  StreamSubscription<String> onErrorSocketSub;
  StreamSubscription<Message> onMessageSub;
  List<Message> messages = [];

  NavigationService _navigationService = locator<NavigationService>();
  RoomService _roomService = locator<RoomService>();
  UserService _userService = locator<UserService>();
  RoomWsService _roomWsService = locator<RoomWsService>();
  ChatWsService _chatWsService = locator<ChatWsService>();
  SocketManager _socketManager = locator<SocketManager>();

  TextEditingController textInputController;

  RoomViewModel(this.socket, this.roomId, this.credentials, this.userId) {
    textInputController = TextEditingController();
  }
  
  init() async {
    onRoomClosedSub = _roomWsService.onRoomClosed.listen(
      (_) {
        _navigationService.navigateTo(Routes.HOME, arguments: HomeViewArguments(credentials, userId));
      }
    );

    onErrorSocketSub = _socketManager.onError.listen((errorMsg) {
      print('Oops! $errorMsg');
    });

    room = await _roomService.getRoomById(roomId, credentials.token);
    messages = room.messages; // Initial messages; Is this info always duplicated? What's the purpose of this field in room?

    user = await _userService.getUser(userId, credentials.token);
    final opponentId = room.users.firstWhere((id) => id != userId);
    opponent = await _userService.getUser(opponentId, credentials.token);
    
    _chatWsService.startListeningToMessages(socket);

    onMessageSub = _chatWsService.onMessage.listen((message) {
      messages.add(message);
      notifyListeners();
    });
  }

  isMessageFromUser(Message msg) => userId == msg.userId;

  void sendMessage() {
    final input = textInputController.text;
    final message = Message(text: input, userId: user.id.id);
    _chatWsService.sendMessage(socket, message);
    messages.add(message);
    textInputController.clear();
    notifyListeners();
  }
}