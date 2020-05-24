import 'package:web/global.dart';
import 'package:web/models/boat.dart';
import 'package:web/models/message.dart';
import 'package:web/models/point.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:web/services/navigation/router.dart';
import 'package:web/services/websockets/boat_placement_ws_service.dart';
import 'package:web/services/websockets/chat_ws_service.dart';
import 'package:web/services/websockets/room_ws_service.dart';
import 'package:web/services/websockets/socket_manager.dart';

void main() async {
  await setupLocator();
  runApp(App());
}

ThemeData AngryShipsTheme(BuildContext context) => ThemeData(
      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Poppins',
          ),
    );

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Angry Ships',
        color: Colors.white,
        navigatorKey: locator<NavigationService>().navigatorKey,
        onGenerateRoute: RoutesGenerator.onGenerateRoute,
        initialRoute: Routes.LOAD,
        theme: AngryShipsTheme(context));
  }

  // Example code, delete later
  testWebSocket() async {
    final token =
        "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImY1YzlhZWJlMjM0ZGE2MDE2YmQ3Yjk0OTE2OGI4Y2Q1YjRlYzllZWIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vYW5ncnktc2hpcHMtMTU4OTA1NjQ3MDc1MiIsImF1ZCI6ImFuZ3J5LXNoaXBzLTE1ODkwNTY0NzA3NTIiLCJhdXRoX3RpbWUiOjE1OTAzMzIwNTEsInVzZXJfaWQiOiJXYmhDNlo1eXhZVjdMdU9SaTZZZUZrbFJqOVEyIiwic3ViIjoiV2JoQzZaNXl4WVY3THVPUmk2WWVGa2xSajlRMiIsImlhdCI6MTU5MDMzMjA1MSwiZXhwIjoxNTkwMzM1NjUxLCJlbWFpbCI6InRlc3RAdGVzdC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsidGVzdEB0ZXN0LmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6InBhc3N3b3JkIn19.biAdWLODP6hYGJX8Uehft3rJlclvIAdN5u2o4OjK2tYKKgAqMUfEZ8cRrKYteST6ofKQeQhv6uMVSLgx1uuxczH-HjxgUqPYbowwecpzoD5gDDNycMlHUU7f-8c2Vl34R-6cMFtyvHq0dUIw3mhisl40Tmw8xeDCzGGkhyXLnkCmllv_yusv9BuZ0KvbdlQ47-458rZoUp0LDaJVQNKFOw6Zt8jow9lnk_mJjqtiLUq8F23CF5wEmhKra6O6BtXdBew4DwknOS7ktVfn7wqtWUqdZWWh0joEvJ95IMV3zSlS20hR5JILAV-7LeLy_DZdERriCMcIgqtDLqTwyiPCVQ";
    final url = "http://localhost:3000";

    final socketManager = new SocketManager(url);
    final roomWsService = new RoomWsService();
    final chatWsService = new ChatWsService();
    final boatPlacementWsService = new BoatPlacementWsService();

    final socket = await socketManager.connect(token);

    roomWsService.findRoom(socket);
    chatWsService.startListeningToMessages(socket);
    boatPlacementWsService.startListeningToOpponentPlaced(socket);

    roomWsService.onRoomOpened.listen((roomId) {
      print('Room opened with id: $roomId');
      chatWsService.sendMessage(socket, Message(text: "Hello!", userId: '123'));
      boatPlacementWsService
          .placeBoats(getBoats(), socket)
          .then((boats) => {print('Boats with errors: ${boats.length}')});
    });

    roomWsService.onRoomClosed.listen((_) {
      print('Room closed');
    });

    socketManager.onError.listen((errorMessage) {
      print('Error: $errorMessage');
    });

    chatWsService.onMessage.listen((message) {
      print('Message [${message.userId}]: ${message.text}');
    });

    boatPlacementWsService.onOpponentPlacedBoats.listen((_) {
      print('Opponent placed boats');
    });
  }

  List<Boat> getBoats() {
    return [
      Boat(
          pivot: Point(0, 0),
          points: [Point(0, 0), Point(0, 1)],
          boatType: BoatType.SMALL),
      Boat(
          pivot: Point(1, 0),
          points: [Point(1, 0), Point(1, 1)],
          boatType: BoatType.SMALL),
      Boat(
          pivot: Point(2, 0),
          points: [Point(2, 0), Point(2, 1)],
          boatType: BoatType.SMALL),
      Boat(
          pivot: Point(0, 2),
          points: [Point(0, 2), Point(0, 3), Point(0,4)],
          boatType: BoatType.NORMAL),
      Boat(
          pivot: Point(1, 2),
          points: [Point(1, 2), Point(1, 3), Point(1,4)],
          boatType: BoatType.NORMAL),
      Boat(
          pivot: Point(3, 0),
          points: [Point(3, 0), Point(4, 0), Point(5, 0), Point(6, 0)],
          boatType: BoatType.BIG),
      Boat(
          pivot: Point(3, 1),
          points: [Point(3, 1), Point(4, 1), Point(5, 1), Point(6, 1), Point(7, 1)],
          boatType: BoatType.EXTRA_BIG),
    ];
  }
}
