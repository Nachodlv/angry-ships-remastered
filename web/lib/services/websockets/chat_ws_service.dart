import 'dart:async';
import 'dart:convert';

import 'package:web/models/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatWsService {
  StreamController<Message> _messageController;

  ChatWsService() {
    _messageController = new StreamController();
  }

  void startListeningToMessages(IO.Socket socket) {
    socket.on('message', (message) => _messageController.add(Message.fromJson(message)));
  }

  void sendMessage(IO.Socket socket, Message message) {
    socket.emit('message',
        {'text': message.text, 'userId': message.userId});
  }

  Stream<Message> get onMessage => _messageController.stream;
}
