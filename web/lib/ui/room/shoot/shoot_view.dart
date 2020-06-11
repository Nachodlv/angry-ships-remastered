import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/models/boat.dart';
import 'package:web/ui/room/grid_view.dart';
import 'package:web/ui/room/shoot/shoot_viewmodel.dart';
import 'package:web/widgets/error_text.dart';
import 'package:web/widgets/timer.dart';

import '../../../global.dart';

class ShootViewArguments {
  final Socket socket;
  final bool firstTurn;
  final List<Boat> boats;

  ShootViewArguments({@required this.socket, @required this.firstTurn, @required this.boats});
}

class ShootView extends StatelessWidget {
  final ShootViewArguments arguments;

  ShootView({@required this.arguments});

  @override
  Widget build(BuildContext context) {
    final windowHeight = MediaQuery.of(context).size.height;
    final windowWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<ShootViewModel>.reactive(
        viewModelBuilder: () => ShootViewModel(
            socket: arguments.socket, 
            firstTurn: arguments.firstTurn),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text("Time to shoot!"),
                Container(
                    height: windowHeight * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Grid(
                            tileSize: (windowWidth * 0.35) / kTilesPerRow, shoots: model.selfShoots,
                        sunkenBoats: model.opponentSunkenBoats,
                        onGridClicked: model.shoot,),
                        Grid(
                          tileSize: (windowWidth * 0.35) / kTilesPerRow,
                          sunkenBoats: model.selfSunkenBoats,
                          shoots: model.opponentShoots, placedBoats: arguments.boats,)
                      ],
                    )),
                Row(
                  children: [
                    Text("Auto play"),
                    Switch(
                      value: model.autoPlay,
                      onChanged: model.autoPlayToggled,),
                  ],
                ),
                if (model.myTurn) ...[
                  Countdown(
                    duration: ShootViewModel.TURN_DURATION,
                    controller: model.countdownController,
                  ),
                  _randomShootSection(model),
                ]
              ],
            )));
  }

  Widget _randomShootSection(ShootViewModel model) {
    return model.onShoot.when(
        success: (_) => _randomShootButton(model.randomShoot, model.myTurn),
        error: (error) => Column(
              children: [
                _randomShootButton(model.randomShoot, model.myTurn),
                ErrorText(error)
              ],
            ),
        loading: () => CircularProgressIndicator(),
        notAsked: () => _randomShootButton(model.randomShoot, model.myTurn));
  }

  Widget _randomShootButton(Function randomShoot, bool myTurn) {
    return RaisedButton(
      onPressed: myTurn ? randomShoot : null,
      child: Text(myTurn ? 'Random shoot' : 'Waiting for the opponent'),
    );
  }
}
