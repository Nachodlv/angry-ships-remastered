import 'dart:convert';
import 'dart:io';

import 'package:web/models/room.dart';
import 'package:http/http.dart' as http;
import 'package:web/services/exceptions/exceptions.dart';

class RoomService {
  final String url;

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