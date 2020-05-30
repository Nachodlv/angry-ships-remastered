import 'package:web/models/boat.dart';
import 'package:web/services/game/tile_service.dart';

class PieceService {
  Boat rotateBoat(Boat boatToRotate, bool rotateClockwise, {bool shouldOffset = false}){
    final rotationIndex = _getNewRotationIndex(boatToRotate.rotationIndex, rotateClockwise);

    final newPoints = boatToRotate.points.map((p) {
      return TileService.rotatePoint(boatToRotate.pivot, p, rotateClockwise);
    }).toList();

    Boat rotatedBoat = boatToRotate.copyWith(
      points: newPoints
    );

    if(shouldOffset) {
      final canOffset = true; // TODO
      if(!canOffset) {
        rotatedBoat = rotateBoat(rotatedBoat, !rotateClockwise); // back to initial position
      }
    }

    if(_moveIsPossible(rotatedBoat)) {
      return rotatedBoat;
    } else {
      return boatToRotate;
    }
  }
    
  int _getNewRotationIndex(int oldRotationIndex, bool rotateClockwise) {
    int newRotationIndex = rotateClockwise 
      ? oldRotationIndex + 1
      : oldRotationIndex -1;
    return newRotationIndex % 4; // TODO Is this Mod safe?
  }

  // TODO
  bool _moveIsPossible(Boat rotatedBoat) => true;
}