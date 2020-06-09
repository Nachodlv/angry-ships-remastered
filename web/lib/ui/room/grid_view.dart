import 'dart:async';

import 'package:extended_math/extended_math.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web/global.dart';
import 'package:web/models/boat.dart';
import 'package:web/models/point.dart';
import 'package:web/widgets/boat_draggable.dart';

class BoatBucket extends StatelessWidget {
  final bool Function(Boat) isBoatAcceptableInBucket;
  final List<Boat> userBoats;
  final Function(Boat boat) onAcceptBoatInBucket;
  final double tileSize;
  final FocusNode _focusNode = FocusNode();
  final List<BoatDraggableController> controllers;

  BoatBucket({
    @required this.isBoatAcceptableInBucket, 
    this.userBoats = const [], 
    @required this.controllers,
    @required this.onAcceptBoatInBucket,
    @required this.tileSize});

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);

    return Card(
        child: Container(
      height: double.infinity,
      child: RawKeyboardListener(
          onKey: (keyEvent) {
            if (keyEvent.runtimeType.toString() != 'RawKeyDownEvent') return;
            if (keyEvent.data.physicalKey.debugName == "Key R")
              controllers.forEach((element) => element.rotate());
          },
          focusNode: _focusNode,
          child: DragTarget<Boat>(
            builder: (context, candidateData, rejectedData) => GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                padding: const EdgeInsets.all(5.0),
                children: userBoats.map((boat) {
                  final index = userBoats.indexOf(boat);
                  return BoatDraggable(
                    boat,
                    tileSize,
                    key: ValueKey(boat.id),
                    controller: controllers[index],
                  );
                }).toList()),
            onAccept: onAcceptBoatInBucket,
            onWillAccept: isBoatAcceptableInBucket,
          )),
    ));
  }
}

class Grid extends StatelessWidget {
  final List<Boat> placedBoats;
  final bool Function(Boat, Point) isBoatAcceptableInGrid;
  final Function(Boat, Point) onAcceptBoatInGrid;
  final double tileSize;
  final double gridSize;

  Grid(
      {this.placedBoats = const [],
      @required this.tileSize,
      @required this.isBoatAcceptableInGrid,
      @required this.onAcceptBoatInGrid})
      : gridSize = tileSize * kTilesPerRow;

  @override
  Widget build(BuildContext context) {
    final dragTargetFromPoint = (Point point) => DragTarget<Boat>(
          builder: (context, candidateData, rejectedData) => Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                color: Colors.blue),
          ),
          onAccept: (boat) => onAcceptBoatInGrid(boat, point),
          onWillAccept: (boat) => isBoatAcceptableInGrid(boat, point),
        );

    // Obviously doesn't belongs here
    List<DragTarget> targets = [];
    for (int i = 0; i < kTilesPerRow; i++) {
      for (int j = 0; j < kTilesPerRow; j++) {
        targets.add(dragTargetFromPoint(Point(i, j)));
      }
    }

    final dragTargetsLayer = GridView.count(
      crossAxisCount: kTilesPerRow,
      children: targets,
    );

    final placedBoatsLayer = placedBoats.map((boat) {
      return Positioned(
          child: boat.asWidget(tileSize),
          left: tileSize * boat.pivot.column,
          top: tileSize * boat.pivot.row);
    });

    return Padding(
        padding: EdgeInsets.all(30),
        child: Container(
          height: gridSize,
          width: gridSize,
          child: Stack(
            children: [
              Container(
                  height: gridSize, width: gridSize, child: dragTargetsLayer),
              ...placedBoatsLayer,
              // TODO Paint to-be-placed boats
            ],
          ),
        ));
  }
}


extension BoatView on Boat {
  Widget asDraggable(double tileSize) {
    return BoatDraggable(this, tileSize);
  }

  Widget getBox(double tileSize, Color color) {
    return SizedBox(
        height: rotationIndex == 0 ? tileSize * points.length : tileSize,
        width: rotationIndex == 1 ? tileSize * points.length : tileSize,
        child: Container(
          color: color,
        ));
  }

  Widget asWidget(double tileSize) {
    return Container(
      child: getBox(tileSize, Colors.red),
    );
  }
}
