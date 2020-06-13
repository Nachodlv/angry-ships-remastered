import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/models/auth.dart';
import 'package:web/ui/home/home_viewmodel.dart';
import 'package:web/widgets/room_invite/room_invite_dialog.dart';

@immutable
class HomeViewArguments {
  final Credentials userCredentials;
  final String userId;
  final Socket socket;
  final String rematchOpponentId;

  HomeViewArguments(
      {@required this.userCredentials,
      @required this.userId,
      this.socket,
      this.rematchOpponentId = "suwP4nh3n5eksHHO5QBEA4Tn6ik1"});
}

class HomeView extends StatelessWidget {
  final HomeViewArguments arguments;

  HomeView(this.arguments);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(
          credentials: this.arguments.userCredentials,
          userId: this.arguments.userId,
          socket: arguments.socket,
          rematchOpponentId: arguments.rematchOpponentId),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                if (model.socket != null) RoomInviteDialog(model.socket),
                model.roomData.when(
                    success: (_) => Container(),
                    error: (err) =>
                        Column(children: [playButton(model.play), Text(err)]),
                    loading: () => Center(child: CircularProgressIndicator()),
                    notAsked: () => Column(children: [
                          playButton(model.play),
                          _logoutButton(model.signOut)
                        ]))
              ])),
        ),
      ),
    );
  }

  Widget _logoutButton(Function signOut) => RaisedButton(
        padding: EdgeInsets.all(8),
        child: Text(
          'Sign Out',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: signOut,
      );

  Widget playButton(Function play) => RaisedButton(
        padding: EdgeInsets.all(8),
        color: Colors.yellow,
        child: Text(
          'Play!',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: play,
      );
}
