import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:web/models/auth.dart';
import 'package:web/services/exceptions/exceptions.dart';

class UserService {

  final String url;
  UserService(String url): this.url = '$url/user';

  Future<void> createUser(String token) async {
    final res = await http.post(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: token
    });

    switch(res.statusCode) {
      case HttpStatus.ok: return;
      case HttpStatus.conflict: return; // already created
      case HttpStatus.unauthorized: throw UnAuthorizedException();
      default: throw UnknownResponseException();
    }
  }

  Future<User> getUser(String userId, String token) async {
    final res = await http.get('$url/$userId', headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: token});

    switch(res.statusCode) {
      case HttpStatus.ok: return User.fromJson(json.decode(res.body));
      case HttpStatus.notFound: throw NotFoundException();
      default: throw UnknownResponseException();
    }
  }
}
