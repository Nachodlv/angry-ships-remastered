import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/models/auth.dart';
import 'package:web/models/websocket/game_over_response.dart';
import 'package:web/ui/game_over/game_over_viewmodel.dart';
import 'package:web/widgets/room_invite/room_invite_dialog.dart';

class GameOverArguments {
  final Socket socket;
  final String userId;
  final Credentials userCredentials;
  final GameOverResponse gameOverResponse;

  GameOverArguments(
      {@required this.socket,
      @required this.userId,
      @required this.userCredentials,
      @required this.gameOverResponse});
}

class GameOverView extends StatelessWidget {
  final GameOverArguments arguments;

  GameOverView(this.arguments);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GameOverViewModel>.reactive(
        viewModelBuilder: () => GameOverViewModel(
              socket: arguments.socket,
              gameOverResponse: arguments.gameOverResponse,
              userCredentials: arguments.userCredentials,
              userId: arguments.userId,
            ),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
              body: Center(child: Column(
                children: [
                  RoomInviteDialog(model.socket),
                  Text(model.userWon ? 'You win!' : 'You lose!'),
                  RaisedButton(onPressed: model.rematch, child: Text("Rematch"),),
                  RaisedButton(onPressed: model.goHome, child: Text("Home"),),
                ],
              )),
            ));
  }
}
