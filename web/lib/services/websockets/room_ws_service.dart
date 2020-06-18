import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web/models/websocket/find_room_response.dart';
import 'package:web/models/websocket/game_over_response.dart';
import 'package:web/models/websocket/room_ready_response.dart';

class RoomWsService {
  StreamController<String> _roomOpenedController;
  StreamController<void> _roomClosedController;
  StreamController<RoomReadyResponse> _roomReadyController;
  StreamController<GameOverResponse> _gameOverController;
  bool _subscribed = false;
  
  RoomWsService() {
      _roomOpenedController = StreamController.broadcast();
      _roomClosedController = StreamController.broadcast();
      _roomReadyController = StreamController.broadcast();
      _gameOverController = StreamController.broadcast();
  }

  Future<FindRoomResponse> findRoom(IO.Socket socket, {bool private = false, String opponentId}) {
    final completer = Completer<FindRoomResponse>();
    socket.emitWithAck(private ? 'private room' : 'find room', opponentId, ack: (response) {
      final findRoomResponse = FindRoomResponse.fromJson(response);
      completer.complete(findRoomResponse);
    });

    return completer.future;
  }
  
  Future<FindRoomResponse> findPrivateRoom(IO.Socket socket, String opponentId) {
    return findRoom(socket, private: true, opponentId: opponentId);
  }
  
  void cancelFindRoom(IO.Socket socket) {
    return socket.emit('cancel find room');
  }
  
  void subscribe(IO.Socket socket) {
    _subscribeToSocket(socket);
  }
  
  void _subscribeToSocket(IO.Socket socket) {
    if(_subscribed) return;
    _subscribed = true;
    _subscribeOnRoomOpened(socket);
    _subscribeOnRoomClosed(socket);
    _subscribeOnRoomReady(socket);
    _subscribeOnGameOver(socket);
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

  void _subscribeOnGameOver(IO.Socket socket) {
    socket.on('game over', (response) => 
        _gameOverController.add(GameOverResponse.fromJson(response)));
  }
  
  Stream<String> get onRoomOpened => _roomOpenedController.stream;
  Stream<void> get onRoomClosed => _roomClosedController.stream;
  Stream<RoomReadyResponse> get onRoomReady => _roomReadyController.stream;
  Stream<GameOverResponse> get onGameOver => _gameOverController.stream;
}