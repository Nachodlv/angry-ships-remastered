import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/global.dart';
import 'package:web/models/boat.dart';
import 'package:web/ui/room/boat_placement/boat_placement_viewmodel.dart';
import 'package:web/ui/room/grid_view.dart';
import 'package:web/widgets/custom_button.dart';
import 'package:web/widgets/error_text.dart';
import 'package:web/widgets/title_text.dart';

@immutable
class BoatPlacementArgument {
  final Socket socket;
  final Function(List<Boat>) finishPlacingBoats;

  BoatPlacementArgument(
      {@required this.socket, @required this.finishPlacingBoats});
}

class BoatPlacementView extends StatelessWidget {
  final BoatPlacementArgument boatPlacementArgument;

  BoatPlacementView({@required this.boatPlacementArgument});

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;
    final windowHeight = MediaQuery.of(context).size.height;

    return ViewModelBuilder<BoatPlacementViewModel>.reactive(
      viewModelBuilder: () => BoatPlacementViewModel(
          socket: this.boatPlacementArgument.socket,
          finishPlacingBoats: this.boatPlacementArgument.finishPlacingBoats),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Column(
        children: [
          Container(
            height: windowHeight * 0.1,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleText('Place your boats'),
                TitleText(
                  'Press R while dragging to rotate the boats',
                  textSize: 20,
                )
              ],
            )),
          ),
          Container(
              height: windowHeight * 0.70,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BoatBucket(
                        focusNode: model.focusNode,
                        isBoatAcceptableInBucket:
                            model.isBoatAcceptableInBucket,
                        onAcceptBoatInBucket: model.onAcceptBoatInBucket,
                        tileSize: (windowWidth * 0.30) / kTilesPerRow,
                        controllers: model.controllers,
                        userBoats: model.userBoats,
                      ),
                      SizedBox(width: 50),
                      Grid(
                        onAcceptBoatInGrid: model.onAcceptBoatInGrid,
                        isBoatAcceptableInGrid: model.isBoatAcceptableInGrid,
                        tileSize: (windowWidth * 0.30) / kTilesPerRow,
                        placedBoats: model.placedBoats,
                      )
                    ],
                  ),
                ),
              )
          ),
          _placeBoatsSection(model, context)
        ],
      ),
    );
  }

  Widget _placeBoatsSection(BoatPlacementViewModel model, context) => Container(
      height: MediaQuery.of(context).size.height * 0.2,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 10),
      child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: model.boatsPlacedData.when(
              success: (_) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Waiting for the opponent to place his boats",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue[500]),
                  ),
                ],
              ),
              error: (error) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [_buttons(model), ErrorText(error)],
              ),
              loading: () => CircularProgressIndicator(),
              notAsked: () => _buttons(model),
            ),
          )));

  Widget _buttons(BoatPlacementViewModel model) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _placeBoatsButton(model.placeAllBoats, model.userBoats.length),
          SizedBox(
            width: 30,
          ),
          _placeBoatsRandomly(model.placeBoatsRandomly),
        ],
      );

  Widget _placeBoatsButton(Function placeBoats, int boatsInBucket) =>
      CustomButton(
        "Place boats",
        onPressed: placeBoats,
        disabled: boatsInBucket != 0,
      );

  Widget _placeBoatsRandomly(Function randomBoats) =>
      CustomButton("Place boats randomly", onPressed: randomBoats);

//  RaisedButton _button(String text, Function action) =>
//      RaisedButton(
//        padding: EdgeInsets.all(8),
//        child: Text(text,
//          style: TextStyle(
//            fontSize: 20,
//            color: Colors.black,
//            fontWeight: FontWeight.bold,
//          ),
//        ),
//        onPressed: action,
//      );

}
