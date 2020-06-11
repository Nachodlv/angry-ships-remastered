import 'dart:async';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web/models/boat.dart';
import 'package:web/models/websocket/random_boats_response.dart';

class BoatPlacementWsService {
  final StreamController<void> _opponentPlacedController;

  BoatPlacementWsService()
      : _opponentPlacedController = StreamController.broadcast();

  void subscribe(IO.Socket socket) {
    _startListeningToOpponentPlaced(socket);
  }
  
  void _startListeningToOpponentPlaced(IO.Socket socket) {
    socket.on('opponent placed boats', (_) {
      _opponentPlacedController.add('Opponent placed boats');
    });
  }

  Future<List<Boat>> placeBoats(List<Boat> boats, IO.Socket socket) {
    final completer = Completer<List<Boat>>();
    socket.emitWithAck('place boats', {'boats': boats},
        ack: (response) {
              completer.complete(_getBoatListFromDynamic(response[0]));
            });
    return completer.future;
  }
  
  Future<RandomBoatsResponse> placeBoatsRandomly(List<Boat> alreadyPlacedBoats, IO.Socket socket) {
    final completer = Completer<RandomBoatsResponse>();
    socket.emitWithAck('place boats randomly', {'boats': alreadyPlacedBoats}, ack: (res) =>
      completer.complete(RandomBoatsResponse(
          _getBoatListFromDynamic(res[0]), 
          _getBoatListFromDynamic(res[1])))
    );
    return completer.future;
  }
  
  List<Boat> _getBoatListFromDynamic(dynamic data) =>
    List<dynamic>.from(data).map((boat) => Boat.fromJson(boat)).toList();
  

  Stream<void> get onOpponentPlacedBoats => _opponentPlacedController.stream;
}
