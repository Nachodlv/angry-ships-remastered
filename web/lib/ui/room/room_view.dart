import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/data_structures/remote_data.dart';
import 'package:web/models/auth.dart';
import 'package:web/ui/room/boat_placement/boat_placement_view.dart';
import 'package:web/ui/room/boat_placement/boat_placement_viewmodel.dart';
import 'package:web/ui/room/grid_view.dart';
import 'package:web/ui/room/room_viewmodel.dart';
import 'package:web/ui/room/shoot/shoot_view.dart';
import 'package:web/widgets/chat/chat_view.dart';

@immutable
class RoomViewArguments {
  final String id;
  final Socket socket;
  final String userId;
  final Credentials userCredentials;

  RoomViewArguments({this.socket, this.id, this.userCredentials, this.userId}) {
    print("Room view arguments constructed");
  }
}

class RoomView extends StatelessWidget {
  final RoomViewArguments arguments;

  RoomView(this.arguments);

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<RoomViewModel>.reactive(
        viewModelBuilder: () => RoomViewModel(
            socket: this.arguments.socket,
            roomId: this.arguments.id,
            credentials: this.arguments.userCredentials,
            userId: this.arguments.userId),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.blue[300],
              body: Row(
                children: [
                  Container(
                    width: windowWidth * 0.8,
                    child: model.boatsPlaced
                        ? ShootView(
                            arguments: ShootViewArguments(
                                boats: model.boats,
                                socket: model.socket,
                                firstTurn: model.firstTurn))
                        : BoatPlacementView(
                            boatPlacementArgument: BoatPlacementArgument(
                                finishPlacingBoats: model.finishPlacingBoats,
                                socket: model.socket),
                          ),
                  ),
                  Container(
                    width: windowWidth * 0.2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: model.user != null &&
                              model.opponent != null &&
                              model.room != null
                          ? ChatView(ChatViewArguments(
                              user: model.user,
                              opponent: model.opponent,
                              socket: model.socket,
                              room: model.room))
                          : Container(),
                    ),
                  )
                ],
              ),
            ));
  }
}
