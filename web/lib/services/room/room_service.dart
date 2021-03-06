import 'dart:convert';
import 'dart:io';

import 'package:extended_math/extended_math.dart';
import 'package:web/models/boat.dart';
import 'package:web/models/point.dart';
import 'package:web/models/room.dart';
import 'package:http/http.dart' as http;
import 'package:web/services/exceptions/exceptions.dart';

import '../../utils.dart';

class RoomService {
  final String url;

  // TODO Is this the place to place such data? 
  static List<Boat> get startingBoats => [
    _startingBoatByType(BoatType.SMALL),
    _startingBoatByType(BoatType.SMALL),
    _startingBoatByType(BoatType.SMALL),
    _startingBoatByType(BoatType.NORMAL),
    _startingBoatByType(BoatType.NORMAL),
    _startingBoatByType(BoatType.BIG),
    _startingBoatByType(BoatType.EXTRA_BIG),
  ];

  static _startingBoatByType(BoatType type) {
   

    final pivot = Point(0, 0);

    final createPointList = (int size) =>
      List.generate(size, (index) => Point(index, 0));

    switch(type) {
      case BoatType.SMALL:
        return Boat(
            id: generateRandomId(), 
            pivot: pivot, 
            points: createPointList(2), 
            boatType: BoatType.SMALL
        );
      case BoatType.NORMAL:
        return Boat(
            id: generateRandomId(), 
            pivot: pivot, 
            points: createPointList(3), 
            boatType: BoatType.NORMAL
        );
      case BoatType.BIG:
        return Boat(
            id: generateRandomId(), 
            pivot: pivot, 
            points: createPointList(4), 
            boatType: BoatType.BIG
        );
      case BoatType.EXTRA_BIG:
        return Boat(
            id: generateRandomId(), 
            pivot: pivot, 
            points: createPointList(5), 
            boatType: BoatType.EXTRA_BIG
        );
    }
  }

  RoomService(String url): this.url = '$url/room';

  Future<Room> getRoomById(String roomId, String token) async {
    final res = await http.get('$url/$roomId', headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: token
    });

    switch(res.statusCode) {
      case HttpStatus.ok: return Room.fromJson(json.decode(res.body));
      case HttpStatus.notFound: throw NotFoundException();
      default: throw UnknownResponseException();
    }
  }
}