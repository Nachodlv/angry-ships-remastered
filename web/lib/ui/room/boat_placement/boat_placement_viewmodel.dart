import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/data_structures/remote_data.dart';
import 'package:web/global.dart';
import 'package:web/models/boat.dart';
import 'package:web/models/point.dart';
import 'package:web/services/room/room_service.dart';
import 'package:web/services/websockets/boat_placement_ws_service.dart';
import 'package:web/widgets/boat_draggable.dart';

class BoatPlacementViewModel extends ChangeNotifier{
  final Socket socket;
  final Function(List<Boat>) finishPlacingBoats;
  
  BoatPlacementWsService _boatPlacementWsService = locator<BoatPlacementWsService>();
  
  StreamSubscription<void> _onOpponentPlacedBoats;
  
  RemoteData<String, Unit> opponentReadyData = RemoteData.notAsked();
  RemoteData<String, Unit> boatsPlacedData = RemoteData.notAsked();
  List<Boat> placedBoats = [];
  List<Boat> userBoats;
  List<BoatDraggableController> controllers;
  
  BoatPlacementViewModel({@required this.socket, @required this.finishPlacingBoats}) {
    userBoats = RoomService.startingBoats;
    controllers = userBoats.map((_) => BoatDraggableController()).toList();
  }
  
  init() {
    _setOpponentReadyData(RemoteData.loading());

    _onOpponentPlacedBoats = _boatPlacementWsService.onOpponentPlacedBoats.listen((_) {
        _setOpponentReadyData(RemoteData<String, Unit>.success(unit));
    });
  }

  void _setOpponentReadyData(RemoteData<String, Unit> remoteData) {
    opponentReadyData = remoteData;
    notifyListeners();
  }

  void placeAllBoats() {
    if(userBoats.length != 0) {
      boatsPlacedData = RemoteData.error("Place all boats first");
      notifyListeners();
      return;
    }
    boatsPlacedData = RemoteData.loading();
    _boatPlacementWsService.placeBoats(placedBoats, socket).then((boats) {
      if(boats.length == 0) {
        finishPlacingBoats(placedBoats);
        boatsPlacedData = RemoteData.success(unit);
      }
      else {
        boatsPlacedData = RemoteData.error("Boats not placed correctly");
        boats.forEach((boat) => placedBoats.remove(boat));
        userBoats.addAll(boats);
      }
      notifyListeners();
    }).catchError((String errorMessage) {
      boatsPlacedData = RemoteData.error(errorMessage);
      notifyListeners();
    });
    notifyListeners();
  }

  void onAcceptBoatInGrid(Boat boat, Point point) {
    boat.pivot = point;
    placedBoats.add(boat);
    userBoats.remove(boat);
    notifyListeners();
  }

  void onAcceptBoatInBucket(Boat boat) {
    placedBoats.remove(boat);
    userBoats.add(boat);
    notifyListeners();
  }

  bool isBoatAcceptableInBucket(Boat boat) =>
      placedBoats.where((b) => b.id == boat.id).isNotEmpty;

  bool isBoatAcceptableInGrid(Boat boat, Point point) {
    if(boat.rotationIndex == 0 && point.row + boat.points.length > kTilesPerRow) return false;
    if(boat.rotationIndex == 1 && point.column + boat.points.length > kTilesPerRow) return false;
    if(_isOverlapping(boat, point)) return false;
    return userBoats
        .where((b) => b.id == boat.id)
        .isNotEmpty;
  }

  void placeBoatsRandomly() {
    boatsPlacedData = RemoteData.loading();
    _boatPlacementWsService.placeBoatsRandomly(placedBoats, socket).then((res) {
      res.boatsWithErrors.forEach((boat) => placedBoats.remove(boat));
      placedBoats.addAll(res.boats);
      userBoats = [];
      boatsPlacedData = RemoteData.success(unit);
      finishPlacingBoats(placedBoats);
      notifyListeners();
    }).catchError((errorMessage) {
      boatsPlacedData = RemoteData.error(errorMessage);
      notifyListeners();
    });
    notifyListeners();
  }
  

  @override
  void dispose() {
    _onOpponentPlacedBoats.cancel();
    super.dispose();
  }

  bool _isOverlapping(Boat boat, Point pivot) {
    for (var placeBoat in placedBoats) {
      for (var point in placeBoat.globalPoints()) {
        print('Placed boat point: (${point.row}, ${point.column})');
        for (var possiblePoint in boat.globalPoints(point: pivot)) {
          if(point == possiblePoint) return true;
        }
      }
    }
    return false;
  }
}