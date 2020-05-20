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
          padding: EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: model.messages.length,
            itemBuilder: (context, index) {
              final msg = model.messages[index];
              return Card(
                child: Text('${msg.userId} said: ${msg.text}')
              );
          }),
        ),
      ),
    );
  }
}