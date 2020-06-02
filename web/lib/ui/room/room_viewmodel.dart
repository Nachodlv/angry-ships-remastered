import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/data_structures/remote_data.dart';
import 'package:web/global.dart';
import 'package:web/models/auth.dart';
import 'package:web/models/boat.dart';
import 'package:web/models/message.dart';
import 'package:web/models/point.dart';
import 'package:web/models/room.dart';
import 'package:web/models/websocket/room_ready_response.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/room/room_service.dart';
import 'package:web/services/user/user_service.dart';
import 'package:web/services/websockets/boat_placement_ws_service.dart';
import 'package:web/services/websockets/chat_ws_service.dart';
import 'package:web/services/websockets/room_ws_service.dart';
import 'package:web/services/websockets/shoot_ws_service.dart';
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
  StreamSubscription<RoomReadyResponse> onRoomReadySub;
  StreamSubscription<Point> onOpponentShoot;
  StreamSubscription<void> onTurnStart;
  TextEditingController textInputController;

  List<Message> messages = [];
  List<Boat> placedBoats = [];
  RemoteData<String, Unit> opponentReadyData = RemoteData.notAsked();
  List<Boat> userBoats = RoomService.startingBoats;

  NavigationService _navigationService = locator<NavigationService>();
  RoomService _roomService = locator<RoomService>();
  UserService _userService = locator<UserService>();
  RoomWsService _roomWsService = locator<RoomWsService>();
  ChatWsService _chatWsService = locator<ChatWsService>();
  BoatPlacementWsService _boatPlacementWsService = locator<BoatPlacementWsService>();
  ShootWsService _shootWsService = locator<ShootWsService>();
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

    _boatPlacementWsService.startListeningToOpponentPlaced(socket);
    _setOpponentReadyData(RemoteData.loading());
            
    _boatPlacementWsService.onOpponentPlacedBoats.listen((_) => 
      _setOpponentReadyData(RemoteData.success(unit)));

    _shootWsService.startListeningToOpponentShoots(socket);
    _shootWsService.startListeningToTurnStart(socket);
    
    onRoomReadySub = _roomWsService.onRoomReady.listen((roomReady) {
      if(roomReady.firstUser == userId) {
        print("I start playing!");
        _shootWsService.makeShoot(socket, Point(1,1)).then((result) => print('Shoot made: ${result.toString()}'));
      } else print("I don't start :(");
    });

    onOpponentShoot = _shootWsService.onOpponentShoot.listen((point) => print('Opponent shot at ${point.toString()}'));
    
    onTurnStart = _shootWsService.onTurnStart.listen((_) => print('It is my turn!'));
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
  
  @override
  void dispose() {
    onRoomClosedSub.cancel();
    onErrorSocketSub.cancel();
    onMessageSub.cancel();
    onRoomReadySub.cancel();
    super.dispose();
  }

  void _setOpponentReadyData(RemoteData remoteData) {
    opponentReadyData = remoteData;
    notifyListeners();
  }

  void onAcceptBoatInGrid(Boat boat, Point point) {
    final placedBoat = boat.copyWith(pivot: point);
    placedBoats.add(placedBoat);
    userBoats.removeWhere((b) => b.id.id == boat.id.id);
    print('On ${point.row}, ${point.column}: Placed $boat!!!!!!');
    notifyListeners();
  }

  void onAcceptBoatInBucket(Boat boat) {
    placedBoats.removeWhere((b) => b.id.id == boat.id.id);
    userBoats.add(
      boat.copyWith(
        pivot: Point(0,0)
      )
    );
    notifyListeners();
  }

  bool isBoatAcceptableInBucket(Boat boat) =>
    placedBoats.where((b) => b.id.id == boat.id.id).isNotEmpty;

  bool isBoatAcceptableInGrid(Boat boat) =>
    userBoats.where((b) => b.id.id == boat.id.id).isNotEmpty;
}