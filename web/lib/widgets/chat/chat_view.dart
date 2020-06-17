import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/models/auth.dart';
import 'package:web/models/room.dart';
import 'package:web/widgets/chat/chat_viewmodel.dart';

class ChatViewArguments {
  final User user;
  final User opponent;
  final Socket socket;
  final Room room;

  ChatViewArguments({this.user, this.opponent, this.socket, this.room});
}

class ChatView extends StatelessWidget {
  final ChatViewArguments arguments;

  ChatView(this.arguments);

  @override
  Widget build(BuildContext context) {
    final windowHeight = MediaQuery.of(context).size.height;

    return ViewModelBuilder<ChatViewModel>.reactive(
        viewModelBuilder: () => ChatViewModel(
            socket: this.arguments.socket,
            user: this.arguments.user,
            opponent: this.arguments.opponent,
            room: this.arguments.room),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Card(
              color: Colors.white.withAlpha(100),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: windowHeight * 0.8,
                      child: ListView.builder(
                          reverse: true,
                          itemCount: model.messages.length,
                          itemBuilder: (context, index) {
                            final msg = model.messages[index];
                            final isMessageFromUser =
                                model.isMessageFromUser(msg);
                            final userData =
                                isMessageFromUser ? model.user : model.opponent;
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: isMessageFromUser
                                        ? Colors.blue[300]
                                        : Colors.blue[400],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: ListTile(
                                  title: Text(
                                    msg.text,
                                    textAlign: isMessageFromUser
                                        ? TextAlign.end
                                        : TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  subtitle: Text(userData.name,
                                      textAlign: isMessageFromUser
                                          ? TextAlign.end
                                          : TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                ),
                              ),
                            );
                          }),
                    ),
                    Container(
                      height: windowHeight * 0.1,
                      child: _input(model, context),
                    )
                  ],
                ),
              ),
            ));
  }

  Widget _input(ChatViewModel model, BuildContext context) => Form(
        key: model.formKey,
        child: Row(children: [
          Expanded(
              child: TextFormField(
                focusNode: model.focusNode,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400])),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white))),
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white, fontSize: 20),
            controller: model.textInputController,
            onFieldSubmitted: (_) {
              model.sendMessage();
              FocusScope.of(context).requestFocus(model.focusNode);
            },
          )),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: model.sendMessage,
            color: Colors.blue[400],
          )
        ]),
      );
}
