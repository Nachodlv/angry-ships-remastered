import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web/models/websocket/find_room_response.dart';
import 'package:web/models/websocket/room_ready_response.dart';

class RoomWsService {
  StreamController<String> _roomOpenedController;
  StreamController<void> _roomClosedController;
  StreamController<RoomReadyResponse> _roomReadyController;
  
  RoomWsService() {
      _roomOpenedController = StreamController.broadcast();
      _roomClosedController = StreamController.broadcast();
      _roomReadyController = StreamController.broadcast();
  }

  Future<FindRoomResponse> findRoom(IO.Socket socket) {
    final completer = Completer<FindRoomResponse>();
    socket.emitWithAck('find room', null, ack: (response) {
      final findRoomResponse = FindRoomResponse.fromJson(response);
      completer.complete(findRoomResponse);
      if(findRoomResponse.startFinding) {
        _subscribeOnRoomOpened(socket);
        _subscribeOnRoomClosed(socket);
        _subscribeOnRoomReady(socket);
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
  
  void _subscribeOnRoomReady(IO.Socket socket) {
    socket.on('room ready', (response) {
      _roomReadyController.add(RoomReadyResponse.fromJson(response));
    });
  }

  Stream<String> get onRoomOpened => _roomOpenedController.stream;
  Stream<void> get onRoomClosed => _roomClosedController.stream;
  Stream<RoomReadyResponse> get onRoomReady => _roomReadyController.stream;
}