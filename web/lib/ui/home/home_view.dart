import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:web/models/auth.dart';
import 'package:web/ui/home/home_viewmodel.dart';

@immutable
class HomeViewArguments {
  final Credentials userCredentials;
  final String userId;

  HomeViewArguments(this.userCredentials, this.userId);
}

class HomeView extends StatelessWidget {
  final HomeViewArguments arguments;

  HomeView(this.arguments);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(this.arguments.userCredentials, this.arguments.userId),
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
                  notAsked: () => playButton(model.play)
                )]
              )
          ),
        ),
      ),
    );
  }

  Widget playButton(Function play) => 
    FlatButton(
      child: Text('Play!',
        style: TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.yellow
        ),
      ),
      onPressed: play,
    );
}