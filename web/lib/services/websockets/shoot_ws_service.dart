﻿import 'dart:async';

import 'package:web/models/point.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web/models/websocket/shoot_response.dart';

class ShootWsService {
  final StreamController<Point> _opponentShootController;
  final StreamController<void> _startTurnController;
  final StreamController<ShootResponse> _timeoutTurnController;

  ShootWsService()
      : _opponentShootController = StreamController.broadcast(),
        _startTurnController = StreamController.broadcast(), 
        _timeoutTurnController = StreamController.broadcast();

  void startListeningToOpponentShoots(IO.Socket socket) {
    socket.on('opponent shoot',
        (shoot) => _opponentShootController.add(Point.fromJson(shoot)));
  }

  void startListeningToTurnStart(IO.Socket socket) {
    socket.on('start turn', (_) => _startTurnController.add('Turn started'));
  }
  
  void startListeningToTurnTimeOut(IO.Socket socket) {
    socket.on('turn timeout', (response) => 
        _timeoutTurnController.add(ShootResponse.fromJson(response)));
  }
  
  Future<ShootResponse> makeShootRandomly(IO.Socket socket) {
    final completer = Completer<ShootResponse>();
    socket.emitWithAck('random shoot', null,
        ack: (response) {
            completer.complete(ShootResponse.fromJson(response));
        });
    return completer.future;
  }

  Future<ShootResponse> makeShoot(IO.Socket socket, Point shoot) {
    final completer = Completer<ShootResponse>();
    socket.emitWithAck('shoot', shoot, ack: (response) {
      completer.complete(ShootResponse.fromJson(response));
    });
    return completer.future;
  }

  Stream<Point> get onOpponentShoot => _opponentShootController.stream;
  Stream<void> get onTurnStart => _startTurnController.stream;
  Stream<ShootResponse> get onTimeoutTurn => _timeoutTurnController.stream;
}
