import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:web/models/auth.dart';
import 'package:web/ui/home/home_viewmodel.dart';

@immutable
class HomeViewArguments {
  final Credentials userCredentials;
  final String userId;

  HomeViewArguments({this.userCredentials, this.userId});
}

class HomeView extends StatelessWidget {
  final HomeViewArguments arguments;

  HomeView(this.arguments);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(credentials: this.arguments.userCredentials, userId: this.arguments.userId),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                model.roomData.when(
                  success: (_) => Container(), 
                  error: (err) => Column(children: [
                    playButton(model.play),
                    Text(err)]
                  ), 
                  loading: () => Center(child: CircularProgressIndicator()), 
                  notAsked: () => 
                      Column(children: [
                        playButton(model.play),
                        _logoutButton(model.signOut)
                      ])
                )]
              )
          ),
        ),
      ),
    );
  }
  
  Widget _logoutButton(Function signOut) => 
    RaisedButton(
      padding: EdgeInsets.all(8), 
      child: Text('Sign Out', style: TextStyle(fontSize: 20),), 
      onPressed: signOut,);

  Widget playButton(Function play) => 
    RaisedButton(
      padding: EdgeInsets.all(8),
      color: Colors.yellow,
      child: Text('Play!',
        style: TextStyle(
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: play,
    );
}