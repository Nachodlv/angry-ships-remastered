import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/data_structures/remote_data.dart';
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
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
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
                _placeBoatsSection(model, context),
                  ]
              )),
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
  
  Widget _placeBoatsSection(RoomViewModel model, context) =>
    Container(
      height: MediaQuery.of(context).size.height * 0.2,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 10),
      child: model.boatsPlacedData.when(success: (_) => Column(
        children: [
          CircularProgressIndicator(),
          Text(
              "Waiting for the opponent to place his boats"),
        ],
      ), error: (error) => 
          Column(children: [
            _placeBoatsButton(model.placeAllBoats), 
            _placeBoatsRandomly(model.placeBoatsRandomly),
            Text(error)
          ],), 
          loading: () => CircularProgressIndicator(), 
          notAsked: () => Column(
            children: [
              _placeBoatsButton(model.placeAllBoats),
              _placeBoatsRandomly(model.placeBoatsRandomly),
            ],
          ))
    );
 

  Widget _placeBoatsButton(Function placeBoats) =>
      _button("Place buttons", placeBoats);
  
  Widget _placeBoatsRandomly(Function randomBoats) =>
    _button("Place boats randomly", randomBoats);
  
  RaisedButton _button(String text, Function action) =>
      RaisedButton(
        padding: EdgeInsets.all(8),
        child: Text(text,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: action,
      );
    
    
}
