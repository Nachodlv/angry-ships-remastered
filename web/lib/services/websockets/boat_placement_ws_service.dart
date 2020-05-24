import 'dart:async';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web/models/boat.dart';

class BoatPlacementWsService {
  final StreamController<void> _opponentPlacedController;

  BoatPlacementWsService()
      : _opponentPlacedController = StreamController.broadcast();

  void startListeningToOpponentPlaced(IO.Socket socket) {
    socket.on('opponent placed boats', (_) {
      _opponentPlacedController.add('Opponent placed boats');
    });
  }

  Future<List<Boat>> placeBoats(List<Boat> boats, IO.Socket socket) {
    final completer = Completer<List<Boat>>();
    socket.emitWithAck('place boats', {'boats': boats},
        ack: (response) {
              completer.complete(List<dynamic>.from(response[0]).map((boat) => Boat.fromJson(boat)).toList());
            });
    return completer.future;
  }

  Stream<void> get onOpponentPlacedBoats => _opponentPlacedController.stream;
}
