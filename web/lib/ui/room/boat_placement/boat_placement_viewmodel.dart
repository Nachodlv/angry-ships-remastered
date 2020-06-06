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

class BoatPlacementViewModel extends ChangeNotifier{
  final Socket socket;

  BoatPlacementWsService _boatPlacementWsService = locator<BoatPlacementWsService>();
  
  StreamSubscription<void> _onOpponentPlacedBoats;
  
  RemoteData<String, Unit> opponentReadyData = RemoteData.notAsked();
  RemoteData<String, Unit> boatsPlacedData = RemoteData.notAsked();
  List<Boat> placedBoats = [];
  List<Boat> userBoats = RoomService.startingBoats;
  
  BoatPlacementViewModel({@required this.socket});
  
  init() {
    _boatPlacementWsService.startListeningToOpponentPlaced(socket);
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
        boatsPlacedData = RemoteData.success(unit);
      }
      else {
        boatsPlacedData = RemoteData.error("Boats not placed correctly");
        boats.forEach((boat) { placedBoats.removeWhere((element) => boat.id == element.id); });
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
    final placedBoat = boat.copyWith(pivot: point);
    placedBoats.add(placedBoat);
    userBoats.removeWhere((b) => b.id == boat.id);
    print('On ${point.row}, ${point.column}: Placed $boat!!!!!!');
    notifyListeners();
  }

  void onAcceptBoatInBucket(Boat boat) {
    placedBoats.removeWhere((b) => b.id == boat.id);
    userBoats.add(
        boat.copyWith(
            pivot: Point(0,0)
        )
    );
    notifyListeners();
  }

  bool isBoatAcceptableInBucket(Boat boat) =>
      placedBoats.where((b) => b.id == boat.id).isNotEmpty;

  bool isBoatAcceptableInGrid(Boat boat) =>
      userBoats.where((b) => b.id == boat.id).isNotEmpty;


  void placeBoatsRandomly() {
    boatsPlacedData = RemoteData.loading();
    _boatPlacementWsService.placeBoatsRandomly(placedBoats, socket).then((res) {
      res.boatsWithErrors.forEach((boat) => placedBoats.removeWhere((element) => element.id == boat.id));
      placedBoats.addAll(res.boats);
      userBoats = [];
      boatsPlacedData = RemoteData.success(unit);
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

}