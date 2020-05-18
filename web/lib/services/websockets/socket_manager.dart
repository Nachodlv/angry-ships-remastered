import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  final String _url;
  IO.Socket _socket;

  Stream<String> onError;
  StreamController<String> _errorController;

  SocketManager(String url) : this._url = '$url/' {
    _errorController = new StreamController();
    onError = _errorController.stream;
  }

  Future<IO.Socket> connect(String token) async {
    _socket = IO.io(_url, <String, dynamic>{
      'query': 'token=$token',
    });
    _subscribeToOnError();
    return _socket;
  }

  void _subscribeToOnError() {
    _socket.on('error', (error) {
      _errorController.add(error);
    });
  }
}
