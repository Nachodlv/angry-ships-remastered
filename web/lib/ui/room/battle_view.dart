import 'package:extended_math/extended_math.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web/global.dart';
import 'package:web/models/boat.dart';
import 'package:web/ui/room/room_viewmodel.dart';

Widget battle(BuildContext context, RoomViewModel model) {
  final contextSize = MediaQuery.of(context).size;

  return Container(
    decoration: BoxDecoration(color: Colors.green),
    child: Stack(
      children: [
        paintBoatBucket(model.userBoats),
        paintGrid(contextSize, model.onAcceptBoat),
      ],
    ),
  );
}

paintBoatBucket(List<Boat> userBoats) {
  return Card(
    child: Container(
      height: double.infinity,
      child: Placeholder()
    ),
  );
}

paintBoats(Size contextSize, List<Boat> userBoats) => 
  userBoats.map((ub) => ub.asWidget(contextSize));

paintGrid(Size contextSize, void Function(Boat) onAcceptBoat) {
  return DragTarget<Boat>(
    builder: (context, candidateData, rejectedData) => Container(),
    onAccept: onAcceptBoat,
  );
}

extension BoatView on Boat {
  Widget asWidget(Size contextSize) {
    final fieldArea = contextSize.width * contextSize.height;
    final tileSide = sqrt(fieldArea / kTilesQuantity);
    
    return Column(
      children: points.map((p) => SizedBox(
        height: tileSide,
        width: tileSide,
        child: Placeholder(),
      )).toList(),
    );
  }
}