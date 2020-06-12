import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/models/auth.dart';
import 'package:web/models/websocket/game_over_response.dart';
import 'package:web/ui/game_over/game_over_viewmodel.dart';
import 'package:web/widgets/custom_button.dart';
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
              backgroundColor: Colors.blue[300],
              body: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.4),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RoomInviteDialog(model.socket),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              model.userWon ? 'You won!' : 'You lost!',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: model.userWon
                                      ? Colors.yellow[900]
                                      : Colors.red[700]),
                            ),
                          ),
                          CustomButton(
                            "Rematch",
                            onPressed: model.rematch,
                          ),
                          CustomButton(
                            "Home",
                            onPressed: model.goHome,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}
