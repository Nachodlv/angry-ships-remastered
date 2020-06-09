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
import 'package:web/models/websocket/room_ready_response.dart';
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
  bool boatsPlaced = false;
  bool firstTurn = false;
  List<Boat> boats = new List();
  
  StreamSubscription<void> onRoomClosedSub;
  StreamSubscription<String> onErrorSocketSub;
  StreamSubscription<Message> onMessageSub;
  StreamSubscription<RoomReadyResponse> onRoomReadySub;
  TextEditingController textInputController;

  List<Message> messages = [];
 
  NavigationService _navigationService = locator<NavigationService>();
  RoomService _roomService = locator<RoomService>();
  UserService _userService = locator<UserService>();
  RoomWsService _roomWsService = locator<RoomWsService>();
  ChatWsService _chatWsService = locator<ChatWsService>();
  SocketManager _socketManager = locator<SocketManager>();
  
  RoomViewModel({this.socket, this.roomId, this.credentials, this.userId}) {
    textInputController = TextEditingController();
  }
  
  init() async {
    if(credentials == null || userId == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _navigationService.navigateTo(Routes.LOAD));
      return;
    }
    else if(socket == null || roomId == null) {
      _navigationService.navigateTo(Routes.HOME, arguments: HomeViewArguments(
          userCredentials: credentials, userId: userId));
      return;
    }

    onRoomClosedSub = _roomWsService.onRoomClosed.listen(
      (_) async {
        await onRoomClosedSub.cancel();
        _navigationService.navigateTo(Routes.HOME, arguments: HomeViewArguments(userCredentials: credentials, userId: userId));
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

    onRoomReadySub = _roomWsService.onRoomReady.listen((roomReady) {
      boatsPlaced = true;
      firstTurn = roomReady.firstUser == userId;
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
  
  finishPlacingBoats(List<Boat> boats) {
    this.boats = boats;
    notifyListeners();
  }
  
  @override
  void dispose() {
    onRoomClosedSub.cancel();
    onErrorSocketSub.cancel();
    onMessageSub.cancel();
    super.dispose();
  }

}