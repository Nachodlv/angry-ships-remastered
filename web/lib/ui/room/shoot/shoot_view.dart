import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/models/boat.dart';
import 'package:web/ui/room/grid_view.dart';
import 'package:web/ui/room/shoot/shoot_viewmodel.dart';
import 'package:web/widgets/custom_spinner.dart';
import 'package:web/widgets/error_text.dart';
import 'package:web/widgets/timer.dart';
import 'package:web/widgets/title_text.dart';

import '../../../global.dart';

class ShootViewArguments {
  final Socket socket;
  final bool firstTurn;
  final List<Boat> boats;

  ShootViewArguments(
      {@required this.socket, @required this.firstTurn, @required this.boats});
}

class ShootView extends StatelessWidget {
  final ShootViewArguments arguments;

  ShootView({@required this.arguments});

  @override
  Widget build(BuildContext context) {
    //TODO add borders https://pub.dev/packages/outline_gradient_button
    final windowHeight = MediaQuery.of(context).size.height;
    final windowWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<ShootViewModel>.reactive(
        viewModelBuilder: () => ShootViewModel(
            socket: arguments.socket, firstTurn: arguments.firstTurn),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                    height: windowHeight * 0.15,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TitleText(model.myTurn
                              ? "Time to shoot"
                              : "Your opponent is shooting"),
                          if(model.lastShootResponse != null)
                            if(model.lastShootResponse.boatSunken.isSome()) TitleText('You sink an enemy ship!')
                            else if(model.lastShootResponse.boatShoot) TitleText('You hit an enemy ship!')
                            else TitleText('You missed!')
                        ],
                      ),
                    )),
                Container(
                    height: windowHeight * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: windowHeight * 0.05,
                              child: model.myTurn
                                  ? TitleText(
                                      'Click a tile to shoot',
                                      textSize: 25,
                                    )
                                  : null,
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 5)),
                              child: Grid(
                                tileSize: (windowWidth * 0.30) / kTilesPerRow,
                                shoots: model.selfShoots,
                                sunkenBoats: model.opponentSunkenBoats,
                                onGridClicked: model.shoot,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: windowHeight * 0.05,
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 5)),
                              child: Grid(
                                tileSize: (windowWidth * 0.30) / kTilesPerRow,
                                sunkenBoats: model.selfSunkenBoats,
                                shoots: model.opponentShoots,
                                placedBoats: arguments.boats,
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                Container(
                  width: windowWidth * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          TitleText(
                            "Auto play",
                            textSize: 25,
                          ),
                          Switch(
                            value: model.autoPlay,
                            onChanged: model.autoPlayToggled,
                          ),
                        ],
                      ),
                      if (model.myTurn) ...[
                        Row(
                          children: [
                            TitleText(
                              'Time left:',
                              textSize: 25,
                            ),
                            SizedBox(width: 5),
                            Countdown(
                              duration: ShootViewModel.TURN_DURATION,
                              controller: model.countdownController,
                            ),
                          ],
                        ),
                        _randomShootSection(model),
                      ]
                    ],
                  ),
                ),
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
        loading: () => CustomSpinner(),
        notAsked: () => _randomShootButton(model.randomShoot, model.myTurn));
  }

  Widget _randomShootButton(Function randomShoot, bool myTurn) {
    return RaisedButton(
      color: Colors.white,
      onPressed: myTurn ? randomShoot : null,
      child: Text(
        myTurn ? 'Random shoot' : 'Waiting for the opponent',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }
}
