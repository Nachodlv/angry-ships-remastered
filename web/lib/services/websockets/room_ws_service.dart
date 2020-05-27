import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web/models/websocket/find_room_response.dart';

class RoomWsService {
  StreamController<String> _roomOpenedController;
  StreamController<void> _roomClosedController;

  RoomWsService() {
      _roomOpenedController = StreamController.broadcast();
      _roomClosedController = StreamController.broadcast();
  }

  Future<FindRoomResponse> findRoom(IO.Socket socket) {
    final completer = Completer<FindRoomResponse>();
    socket.emitWithAck('find room', null, ack: (response) {
      final findRoomResponse = FindRoomResponse.fromJson(response);
      completer.complete(findRoomResponse);
      if(findRoomResponse.startFinding) {
        _subscribeOnRoomOpened(socket);
        _subscribeOnRoomClosed(socket);
      }
    });

    return completer.future;
  }

  void _subscribeOnRoomOpened(IO.Socket socket) {
    socket.on('room opened', (roomId) {
        _roomOpenedController.add(roomId);
    });
  }

  void _subscribeOnRoomClosed(IO.Socket socket) {
    socket.on('room closed', (_) {
      _roomClosedController.add("Room closed");
    });
  }

  Stream<String> get onRoomOpened => _roomOpenedController.stream;
  Stream<void> get onRoomClosed => _roomClosedController.stream;
}