import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/data_structures/remote_data.dart';
import 'package:web/models/point.dart';
import 'package:web/models/websocket/shoot_response.dart';
import 'package:web/services/websockets/shoot_ws_service.dart';

import '../../../global.dart';

class ShootViewModel extends ChangeNotifier {
  static const TURN_DURATION = Duration(seconds: 5);
  final Socket socket;
  
  bool myTurn = false;
  
  ShootWsService _shootWsService = locator<ShootWsService>();

  StreamSubscription<Point> onOpponentShoot;
  StreamSubscription<void> onTurnStart;
  StreamSubscription<ShootResponse> onTurnTimeout;

  RemoteData<String, Point> onShoot = RemoteData.notAsked();

  ShootViewModel({@required this.socket, @required bool firstTurn}): myTurn = firstTurn;
  
  init() {
    _shootWsService.startListeningToOpponentShoots(socket);
    _shootWsService.startListeningToTurnStart(socket);
    _shootWsService.startListeningToTurnTimeOut(socket);

    onOpponentShoot = _shootWsService.onOpponentShoot
        .listen((point) => print('Opponent shot at ${point.toString()}'));

    onTurnStart =
        _shootWsService.onTurnStart.listen((_) {
          myTurn = true;
          notifyListeners();
        });
    
    onTurnTimeout = _shootWsService.onTimeoutTurn.listen(_handleShootResponse);
  }

  randomShoot() {
    onShoot = RemoteData.loading();
    _shootWsService
        .makeShootRandomly(socket)
        .then(_handleShootResponse)
        .catchError(_handleOnShootError);
    notifyListeners();
  }

  shoot(Point point) {
    onShoot = RemoteData.loading();
    _shootWsService
        .makeShoot(socket, point)
        .then(_handleShootResponse)
        .catchError(_handleOnShootError);
    notifyListeners();
  }

  _handleShootResponse(ShootResponse response) {
    if (response.isValid) {
      onShoot = RemoteData.success(response.point);
      myTurn = false;
    } else
      onShoot = RemoteData.error("Shoot point not valid");
    notifyListeners();
  }

  _handleOnShootError(String error) {
    onShoot = RemoteData.error(error);
    notifyListeners();
  }

  @override
  void dispose() {
    onOpponentShoot.cancel();
    onTurnStart.cancel();
    super.dispose();
  }
}
