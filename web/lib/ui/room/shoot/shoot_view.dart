import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/ui/room/shoot/shoot_viewmodel.dart';
import 'package:web/widgets/error_text.dart';
import 'package:web/widgets/timer.dart';

class ShootViewArguments {
  final Socket socket;
  final bool firstTurn;
  ShootViewArguments({@required this.socket, @required this.firstTurn});
}

class ShootView extends StatelessWidget {
  final ShootViewArguments arguments;
  
  ShootView({@required this.arguments});
  
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShootViewModel>.reactive(
        viewModelBuilder: () => 
            ShootViewModel(
                socket: arguments.socket, 
                firstTurn: arguments.firstTurn),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) =>
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text("Time to shoot!"),
                if(model.myTurn) ...[
                  Countdown(
                    duration: ShootViewModel.TURN_DURATION, 
                    controller: model.countdownController,), 
                  _randomShootSection(model)
                ]
              ],
            )
          )
        );
  }
  
  Widget _randomShootSection(ShootViewModel model) {
    return 
      model.onShoot.when(
          success: (_) => _randomShootButton(model.randomShoot, model.myTurn), 
          error: (error) => Column(children: [_randomShootButton(model.randomShoot, model.myTurn), ErrorText(error)],), 
          loading: () => CircularProgressIndicator(), 
          notAsked: () => _randomShootButton(model.randomShoot, model.myTurn));
  }
  
  Widget _randomShootButton(Function randomShoot, bool myTurn) {
    return RaisedButton(
      onPressed: myTurn? randomShoot : null, 
      child: Text(myTurn ? 'Random shoot' : 'Waiting for the opponent'),);
  }
}
