import 'package:extended_math/extended_math.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web/global.dart';
import 'package:web/models/boat.dart';
import 'package:web/models/point.dart';
import 'package:web/utils.dart';


class Grid extends StatelessWidget {
  final List<Boat> userBoats;
  final List<Boat> placedBoats;
  final bool Function(Boat) isBoatAcceptableInBucket;
  final bool Function(Boat) isBoatAcceptableInGrid;
  final Function(Boat boat) onAcceptBoatInBucket;
  final Function(Boat, Point) onAcceptBoatInGrid;
  
  Grid({
    this.userBoats = const [], 
    this.placedBoats = const [], 
    @required this.isBoatAcceptableInBucket,
    @required this.isBoatAcceptableInGrid,
    @required this.onAcceptBoatInBucket,
    @required this.onAcceptBoatInGrid});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.green),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: _paintBoatBucket(context,
                  userBoats,
                  onAcceptBoatInBucket, isBoatAcceptableInBucket)
          ),
          Expanded(
              flex: 8,
              child: _paintGrid(context,
                  placedBoats,
                  onAcceptBoatInGrid, isBoatAcceptableInGrid)
          ),
        ],
      ),
    );
  }
  
  _paintBoatBucket(BuildContext context, List<Boat> userBoats,
      void Function(Boat) onAcceptBoatInBucket,
      bool Function(Boat) isBoatAcceptableInBucket) {
  
    final contextSize = MediaQuery.of(context).size;
    final tileSide = calculateTileSide(contextSize);
  
    return Card(
      child: Container(
          height: double.infinity,
          child: DragTarget<Boat>(
            builder: (context, candidateData, rejectedData) => GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              padding: const EdgeInsets.all(5.0),
              children:
              userBoats.map((e) => e.asDraggable(tileSide)).toList()
              ,
            ),
            onAccept: onAcceptBoatInBucket,
            onWillAccept: isBoatAcceptableInBucket,
          )
      ),
    );
  }

  _paintGrid(BuildContext context,
      List<Boat> placedBoats,
      void Function(Boat, Point) onAcceptBoatInGrid,
      bool Function(Boat) isBoatAcceptableInGrid) {

    final contextSize = MediaQuery.of(context).size;
    final tileSide = calculateTileSide(contextSize);
    final gridSide = tileSide * kTilesPerRow;

    final dragTargetFromPoint = (Point point) => DragTarget<Boat>(
        builder: (context, candidateData, rejectedData) => Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              color: Colors.blue
          ),
        ),
        onAccept: (Boat boat) => onAcceptBoatInGrid(boat, point),
        onWillAccept: isBoatAcceptableInGrid
    );

    // Obviously doesn't belongs here
    List<DragTarget> targets = [];
    for(int i = 0; i < kTilesPerRow; i++) {
      for(int j = 0; j < kTilesPerRow; j++) {
        targets.add(dragTargetFromPoint(Point(i, j)));
      }
    }

    final dragTargetsLayer = GridView.count(
      crossAxisCount: kTilesPerRow,
      children: targets,
    );

    final placedBoatsLayer = placedBoats.map((boat) {
      final coordinatesToDistance = {
        'left': tileSide * boat.pivot.column,
        'top': tileSide * boat.pivot.row,
      };

      return Positioned(
          child: boat.asWidget(tileSide),
          left: coordinatesToDistance['left'],
          top: coordinatesToDistance['top']
      );
    });

    return Padding(
      padding: EdgeInsets.all(30),
      child: Container(
        height: gridSide,
        width: gridSide,
        child: Stack(
          children: [
            dragTargetsLayer,
            ...placedBoatsLayer,
            // TODO Paint to-be-placed boats
          ],
        ),
      ),
    );
  }

}



extension BoatView on Boat {
  Widget asDraggable(double tileSide) {
    final box = (Color a) => SizedBox(
      height: tileSide,
      width: tileSide,
      child: Container(color: a,)
    );

    return Draggable<Boat>(
      data: this,
      feedback: box(Colors.blue),
      child: Column(
        children: 
          this.points.map((p) => box(Colors.amber)).toList()
      ),
    );
  }

  Widget asWidget(double tileSide){
    final box = (Color a) => SizedBox(
      height: tileSide,
      width: tileSide,
      child: Container(color: a,)
    );

    return Container(
      child: box(Colors.red),
    );
  }
}