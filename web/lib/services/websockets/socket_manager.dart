import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  final String _url;
  IO.Socket _socket;
  StreamController<String> _errorController;

  SocketManager(String url) : this._url = '$url/' {
    _errorController = new StreamController();
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

  Stream<String> get onError => _errorController.stream;
}
