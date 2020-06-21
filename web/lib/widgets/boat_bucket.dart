import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:web/models/boat.dart';
import 'package:web/widgets/boat_draggable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BoatBucket extends StatelessWidget {
  final bool Function(Boat) isBoatAcceptableInBucket;
  final List<Boat> userBoats;
  final Function(Boat boat) onAcceptBoatInBucket;
  final double tileSize;
  final List<BoatDraggableController> controllers;
  final FocusNode focusNode;

  BoatBucket(
      {@required this.isBoatAcceptableInBucket,
        @required this.focusNode,
      this.userBoats = const [],
      @required this.controllers,
      @required this.onAcceptBoatInBucket,
      @required this.tileSize});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 3.5 * tileSize,
        child: Card(
          elevation: 3,
          child: RawKeyboardListener(
              onKey: (keyEvent) {
                if (keyEvent.runtimeType != RawKeyDownEvent)
                  return;
                print(keyEvent.data.keyLabel);
                if (keyEvent.data.keyLabel == "r")
                  controllers.forEach((element) => element.rotate());
              },
              focusNode: focusNode,
              child: DragTarget<Boat>(
                builder: (context, candidateData, rejectedData) =>
                    StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  itemCount: userBoats.length,
                  padding: const EdgeInsets.all(5.0),
                  itemBuilder: (context, index) => BoatDraggable(
                    userBoats[index],
                    tileSize,
                    focusNode: focusNode,
                    key: ValueKey(userBoats[index].id),
                    controller: controllers[index],
                  ),
                  staggeredTileBuilder: (index) =>
                      StaggeredTile.count(1, userBoats[index].points.length),
                ),
                onAccept: onAcceptBoatInBucket,
                onWillAccept: isBoatAcceptableInBucket,
              )),
        ));
  }
}
