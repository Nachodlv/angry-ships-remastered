import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:web/models/auth.dart';
import 'package:web/ui/login/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeLongestSide = MediaQuery.of(context).size.longestSide;

    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.cyan,
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Image(
                  height: sizeLongestSide / 4,
                  fit: BoxFit.scaleDown,
                  image: AssetImage('assets/images/logo.png')),
              ),
              SizedBox(height: 20.0,),
              renderLoginBox(sizeLongestSide, signInWithGoogle: model.signInWithGoogle),
              SizedBox(height: 20.0,),
              model.userState.when(
                success: (SignInState state) =>
                  state.when(
                    (session) => Container(
                      child: Card(child: Text(
                        'Credentials: ${session.credentials}\n'
                        'Provider: ${session.provider}'
                      ))
                    ), 
                    anonymous: () => Text('¡Not logged in!')
                  )
                ,
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err) => Container(color: Colors.red, child: Text('¡Oops! $err')),
                notAsked: () => Container()
              )
            ],
          ),
        ),
      ),
    );
  }
}
            
renderLoginBox(double sizeLongestSide, {void Function() signInWithGoogle}) =>
  RaisedButton(
    color: Colors.white,
    highlightColor: Colors.white,
    splashColor: Colors.grey,
    onPressed: () => signInWithGoogle(),
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
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    ),
  );