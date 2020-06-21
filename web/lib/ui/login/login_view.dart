import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:web/models/auth.dart';
import 'package:web/ui/login/login_viewmodel.dart';
import 'package:web/widgets/custom_spinner.dart';
import 'package:web/widgets/error_text.dart';
import 'package:web/widgets/game_title.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeLongestSide = MediaQuery.of(context).size.longestSide;

    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.blue[300],
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Center(
                child: GameTitle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              _renderLoginBox(sizeLongestSide,
                  signInWithGoogle: model.signInWithGoogle),
              SizedBox(
                height: 20.0,
              ),
              model.userState.when(
                  success: (state) => state.when((UserSession session) {
                        return Container();
                      }, 
                  anonymous: () => Container()),
                  loading: () => Center(child: CustomSpinner()),
                  error: (err) =>
                      ErrorText(err),
                  notAsked: () => Container())
            ],
          ),
        ),
      ),
    );
  }

  _renderLoginBox(double sizeLongestSide, {void Function() signInWithGoogle}) =>
      RaisedButton(
        color: Colors.white,
        highlightColor: Colors.white,
        splashColor: Colors.grey,
        onPressed: signInWithGoogle,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        highlightElevation: 1,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/images/google_logo.png"),
                  height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey[600],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}


