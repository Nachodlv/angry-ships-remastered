﻿import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:web/models/boat.dart';
import 'package:web/models/point.dart';
import 'package:web/models/websocket/shoot_response.dart';

import '../global.dart';

class Grid extends StatelessWidget {
  final List<Boat> placedBoats;
  final List<Boat> sunkenBoats;
  final List<ShootResponse> shoots;
  final bool Function(Boat, Point) isBoatAcceptableInGrid;
  final Function(Boat, Point) onAcceptBoatInGrid;
  final Function(Point) onGridClicked;
  final double tileSize;
  final double gridSize;

  Grid(
      {this.placedBoats = const [],
        this.shoots = const [],
        this.sunkenBoats = const [],
        @required this.tileSize,
        bool Function(Boat, Point) isBoatAcceptableInGrid,
        Function(Boat, Point) onAcceptBoatInGrid,
        Function(Point) onGridClicked})
      : gridSize = tileSize * kTilesPerRow,
        isBoatAcceptableInGrid = isBoatAcceptableInGrid ?? ((_, __) => true),
        onAcceptBoatInGrid = onAcceptBoatInGrid ?? ((_, __) => Unit),
        onGridClicked = onGridClicked ?? ((_) => Unit);

  @override
  Widget build(BuildContext context) {
    final dragTargetFromPoint = (Point point) => DragTarget<Boat>(
      builder: (context, candidateData, rejectedData) => GestureDetector(
        onTap: () => onGridClicked(point),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue[900],
                width: 1,
              ),
              color: Colors.blue),
        ),
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

    return Container(
      height: gridSize,
      width: gridSize,
      child: Stack(
        children: [
          Container(height: gridSize, width: gridSize, child: dragTargetsLayer),
          ..._getPlacedBoats(placedBoats, Colors.white),
          ..._getPlacedBoats(sunkenBoats, Colors.red[900]),
          ..._getShoots()
        ],
      ),
    );
  }

  Iterable<Widget> _getPlacedBoats(List<Boat> boats, Color color) =>
      boats.map((boat) => Positioned(
          child: boat.asWidget(tileSize, color),
          left: tileSize * boat.pivot.column,
          top: tileSize * boat.pivot.row));

  Iterable<Widget> _getShoots() {
    return shoots.map((shoot) {
      return Positioned(
        left: tileSize * shoot.point.column,
        top: tileSize * shoot.point.row,
        child: Container(
          child: SizedBox(
              height: tileSize,
              width: tileSize,
              child: Icon(
                shoot.boatShoot ? Icons.clear : Icons.radio_button_unchecked,
                color: shoots.last == shoot ? Colors.green : Colors.black,
              )),
        ),
      );
    });
  }
}

extension BoatView on Boat {

  Widget getBox(double tileSize, Color color) {
    return SizedBox(
        height: rotationIndex == 0 ? tileSize * points.length : tileSize,
        width: rotationIndex == 1 ? tileSize * points.length : tileSize,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            color: color,
          ),
        ));
  }

  Widget asWidget(double tileSize, Color color) {
    return Container(
      child: getBox(tileSize, color),
    );
  }
}