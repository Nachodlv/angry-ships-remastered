import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/models/websocket/find_room_response.dart';
import 'package:web/models/websocket/game_invite_response.dart';

class RoomInviteWsService {
  StreamController<RoomInviteResponse> _roomInviteController;

  RoomInviteWsService() : _roomInviteController = StreamController.broadcast();

  void subscribe(Socket socket) {
    _subscribeToGameInvites(socket);
  }

  Future<FindRoomResponse> acceptInvite(Socket socket, String roomId) {
    final completer = Completer<FindRoomResponse>();
    socket.emitWithAck('accept invite', roomId,
        ack: (response) =>
            completer.complete(FindRoomResponse.fromJson(response)));
    return completer.future;
  }
  
  void cancelInvite(Socket socket, String roomId) {
    socket.emit('cancel invite', roomId);
  }

  _subscribeToGameInvites(Socket socket) {
    socket.on('invite', (data) {
      print('Invited!!');
      _roomInviteController.add(RoomInviteResponse.fromJson(data));
    });
  }

  Stream<RoomInviteResponse> get onRoomInvite => _roomInviteController.stream;
}
