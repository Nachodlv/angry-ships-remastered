import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/models/auth.dart';
import 'package:web/ui/room/room_viewmodel.dart';

import 'battle_view.dart';

@immutable
class RoomViewArguments {
  final String id;
  final Socket socket;
  final String userId;
  final Credentials userCredentials;

  RoomViewArguments({this.socket, this.id, this.userCredentials, this.userId}) {print("Room view arguments constructed");}
}

class RoomView extends StatelessWidget {
  final RoomViewArguments arguments;

  RoomView(this.arguments);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RoomViewModel>.reactive(
      viewModelBuilder: () => 
          RoomViewModel(
            socket: this.arguments.socket, 
            roomId: this.arguments.id, 
            credentials: this.arguments.userCredentials, 
            userId: this.arguments.userId),
            onModelReady: (model) => model.init(),
            builder: (context, model, child) => Scaffold(
              body: Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: battle(context, model),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: chat(model),
                      ),
                    )
                  ],
                ), 
              ),
            )
    );
  }

  Widget chat(RoomViewModel model) =>
    Column(
      children: [
        Expanded(
          flex: 1,
          child: Row(
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
        ),
        Expanded(
          flex: 9,
          child: ListView.builder(
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
        ),
      ],
    );
}
