import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/data_structures/remote_data.dart';
import 'package:web/models/boat.dart';
import 'package:web/models/point.dart';
import 'package:web/models/websocket/shoot_response.dart';
import 'package:web/services/websockets/shoot_ws_service.dart';
import 'package:web/widgets/timer.dart';

import '../../../global.dart';

class ShootViewModel extends ChangeNotifier {
  static const TURN_DURATION = Duration(seconds: 5);
  final Socket socket;
  final CountDownController countdownController = CountDownController();
  
  bool myTurn = false;
  bool autoPlay = false;
  List<ShootResponse> selfShoots = new List();
  List<ShootResponse> opponentShoots = new List();
  List<Boat> selfSunkenBoats = new List();
  List<Boat> opponentSunkenBoats = new List();
  
  ShootWsService _shootWsService = locator<ShootWsService>();

  StreamSubscription<ShootResponse> onOpponentShoot;
  StreamSubscription<void> onTurnStart;
  StreamSubscription<ShootResponse> onTurnTimeout;

  RemoteData<String, Point> onShoot = RemoteData.notAsked();

  ShootViewModel({@required this.socket, @required bool firstTurn}): 
        myTurn = firstTurn;
  
  init() {
    onOpponentShoot = _shootWsService.onOpponentShoot
        .listen((response) {
          opponentShoots.add(response);
          response.boatSunken.map((boat) => selfSunkenBoats.add(boat));
          notifyListeners();
        });

    onTurnStart =
        _shootWsService.onTurnStart.listen((_) {
          myTurn = true;
          countdownController.resetCountdown();
          if(autoPlay) randomShoot();
          else notifyListeners();
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
  
  autoPlayToggled(bool value) {
    autoPlay = value;
    notifyListeners();
    if(myTurn && value) randomShoot();
  }

  _handleShootResponse(ShootResponse response) {
    if (response.isValid) {
      onShoot = RemoteData.success(response.point);
      selfShoots.add(response);
      response.boatSunken.map((boat) => opponentSunkenBoats.add(boat));
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
    onTurnTimeout.cancel();
    super.dispose();
  }
  
}
