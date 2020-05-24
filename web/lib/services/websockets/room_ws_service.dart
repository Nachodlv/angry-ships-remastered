import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class RoomWsService {
  StreamController<String> _roomOpenedController;
  StreamController<void> _roomClosedController;

  RoomWsService() {
      _roomOpenedController = StreamController.broadcast();
      _roomClosedController = StreamController.broadcast();
  }

  void findRoom(IO.Socket socket) {
    socket.emit('find room', null);
    _subscribeOnRoomOpened(socket);
    _subscribeOnRoomClosed(socket);
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