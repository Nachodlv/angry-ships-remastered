import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class RoomWsService {
  
  Stream<String> onRoomOpened;
  StreamController<String> _roomOpenedController;

  Stream<void> onRoomClosed;
  StreamController<void> _roomClosedController;

  RoomWsService() {
      _roomOpenedController = new StreamController();
      onRoomOpened = _roomOpenedController.stream;
      
      _roomClosedController = new StreamController();
      onRoomClosed = _roomClosedController.stream;
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
}