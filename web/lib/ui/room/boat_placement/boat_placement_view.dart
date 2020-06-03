import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stacked/stacked.dart';
import 'package:web/ui/room/boat_placement/boat_placement_viewmodel.dart';
import 'package:web/ui/room/grid_view.dart';

@immutable
class BoatPlacementArgument {
  final Socket socket;
  final Function finishBoatPlacement;

  BoatPlacementArgument(
      {@required this.socket, @required this.finishBoatPlacement});
}

class BoatPlacementView extends StatelessWidget {
  final BoatPlacementArgument boatPlacementArgument;

  BoatPlacementView({@required this.boatPlacementArgument});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BoatPlacementViewModel>.reactive(
        viewModelBuilder: () => BoatPlacementViewModel(
            socket: this.boatPlacementArgument.socket,
            finishBoatPlacement:
                this.boatPlacementArgument.finishBoatPlacement),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => 
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.6, 
                  child: Grid(
                    isBoatAcceptableInBucket: model.isBoatAcceptableInBucket, 
                    isBoatAcceptableInGrid: model.isBoatAcceptableInGrid, 
                    onAcceptBoatInBucket: model.onAcceptBoatInBucket, 
                    onAcceptBoatInGrid: model.onAcceptBoatInGrid,
                    userBoats: model.userBoats, 
                    placedBoats: model.placedBoats,),
                ),
                _placeBoatsSection(model, context)
              ],
            ));
  }

  Widget _placeBoatsSection(BoatPlacementViewModel model, context) =>
      Container(
          height: MediaQuery.of(context).size.height * 0.2,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 10),
          child: model.boatsPlacedData.when(success: (_) => Column(
            children: [
              CircularProgressIndicator(),
              Text(
                  "Waiting for the opponent to place his boats"),
            ],
          ), error: (error) =>
              Column(children: [
                _placeBoatsButton(model.placeAllBoats),
                _placeBoatsRandomly(model.placeBoatsRandomly),
                Text(error)
              ],),
              loading: () => CircularProgressIndicator(),
              notAsked: () => Column(
                children: [
                  _placeBoatsButton(model.placeAllBoats),
                  _placeBoatsRandomly(model.placeBoatsRandomly),
                ],
              ))
      );


  Widget _placeBoatsButton(Function placeBoats) =>
      _button("Place buttons", placeBoats);

  Widget _placeBoatsRandomly(Function randomBoats) =>
      _button("Place boats randomly", randomBoats);

  RaisedButton _button(String text, Function action) =>
      RaisedButton(
        padding: EdgeInsets.all(8),
        child: Text(text,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: action,
      );

}
