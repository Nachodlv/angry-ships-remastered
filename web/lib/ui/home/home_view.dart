import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/models/auth.dart';
import 'package:web/ui/home/home_viewmodel.dart';
import 'package:web/widgets/custom_spinner.dart';
import 'package:web/widgets/error_text.dart';
import 'package:web/widgets/game_title.dart';
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
      this.rematchOpponentId});
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
        backgroundColor: Colors.blue[300],
        body: Stack(children: [
          Container(
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                if (model.socket != null) RoomInviteDialog(model.socket),
                GameTitle(
                  fontSize: 100,
                ),
                SizedBox(
                  height: 100,
                ),
                model.roomData.when(
                    success: (_) => Container(),
                    error: (err) => _buttonsColumn(model, context, error: err),
                    loading: () => Column(
                          children: [
                            Center(child: CustomSpinner()),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Looking for an opponent...",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _button(model.cancelFindRoom, 'Cancel',
                                fontSize: 30)
                          ],
                        ),
                    notAsked: () => _buttonsColumn(model, context))
              ]),
            )),
          ),
          model.userNameData.when(
              success: (userName) => Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Signed in as $userName',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
              error: (_) => Container(),
              loading: () => Container(),
              notAsked: () => Container())
        ]),
      ),
    );
  }

  Widget _buttonsColumn(HomeViewModel model, BuildContext context,
          {String error}) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        _button(model.play, "Play!"),
        if (error != null) ErrorText(error),
        SizedBox(
          height: 30,
        ),
        Container(width: 400, child: _emailInput(model, context)),
        SizedBox(
          height: 40,
        ),
        _button(model.signOut, "Sign out", fontSize: 25)
      ]);

  Widget _button(Function onPress, String text, {double fontSize = 35}) =>
      RaisedButton(
        elevation: 3,
        padding: EdgeInsets.all(8),
        color: Colors.white,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPress,
      );

  Widget _emailInput(HomeViewModel model, BuildContext context) => Form(
        key: model.formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: model.focusNode,
                decoration: InputDecoration(
                    hintText: 'User email',
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[400])),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white, fontSize: 20),
                controller: model.textInputController,
                onFieldSubmitted: (_) {
                  model.inviteUserByEmail();
                  FocusScope.of(context).requestFocus(model.focusNode);
                },
              ),
            ),
            SizedBox(width: 10,),
            _button(model.inviteUserByEmail, 'Invite user', fontSize: 25)
          ],
        ),
      );
}
