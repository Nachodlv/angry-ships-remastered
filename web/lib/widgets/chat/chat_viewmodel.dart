import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/models/auth.dart';
import 'package:web/models/message.dart';
import 'package:web/models/room.dart';
import 'package:web/services/websockets/chat_ws_service.dart';

import '../../global.dart';

class ChatViewModel extends ChangeNotifier {
  final User user;
  final User opponent;
  final Socket socket;
  final Room room;
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  StreamSubscription<Message> onMessageSub;
  List<Message> messages = [];

  final ChatWsService _chatWsService = locator<ChatWsService>();
  final TextEditingController textInputController;

  ChatViewModel(
      {@required this.socket,
      @required this.user,
      @required this.opponent,
      @required this.room}):
        textInputController = TextEditingController();

  init() {
    messages = room.messages;
    
    onMessageSub = _chatWsService.onMessage.listen((message) {
      messages.insert(0, message);
      notifyListeners();
    });
  }

  void sendMessage() {
    final input = textInputController.text;
    if (input.isEmpty) return;
    final message = Message(text: input, userId: user.id.id);
    _chatWsService.sendMessage(socket, message);
    messages.insert(0, message);
    textInputController.clear();
    notifyListeners();
  }

  isMessageFromUser(Message msg) => user.id.id == msg.userId;

  @override
  void dispose() {
    onMessageSub.cancel();
    super.dispose();
  }
}
