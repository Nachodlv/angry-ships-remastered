import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/models/auth.dart';
import 'package:web/ui/room/room_viewmodel.dart';

@immutable
class RoomViewArguments {
  final String id;
  final Socket socket;
  final String userId;
  final Credentials userCredentials;

  RoomViewArguments(this.socket, this.id, this.userCredentials, this.userId);
}

class RoomView extends StatelessWidget {
  final RoomViewArguments arguments;

  RoomView(this.arguments);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RoomViewModel>.reactive(
      viewModelBuilder: () => RoomViewModel(this.arguments.socket, this.arguments.id, this.arguments.userCredentials, this.arguments.userId),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: model.textInputController,
                    ) 
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: model.sendMessage)
                ]
              ),
              ListView.builder(
                itemCount: model.messages.length,
                itemBuilder: (context, index) {
                  final msg = model.messages[index];
                  final isMessageFromUser = model.isMessageFromUser(msg);
                  final userData = isMessageFromUser
                    ? model.user
                    : model.opponent;
                  return Align(
                    alignment: isMessageFromUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                    child: ListTile(
                      title: Text(msg.text),
                      subtitle: Text(userData.name),
                      selected: isMessageFromUser, // Hacky display of contrast
                    ));
              }),
            ],
          ),
        ),
      ),
    );
  }
}