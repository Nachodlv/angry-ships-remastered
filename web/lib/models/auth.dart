// TODO the only ones capable of creating Credentials / UserSession should be auth services, what is the best way to enforce that restriction?
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';

@immutable
class User {
  final UserID id;
  final String name;
  final String surname;
  final String imageUrl;
  final String email;

  User({
    @required this.id,
    @required this.name,
    @required this.surname,
    @required this.imageUrl,
    @required this.email,
  });

  // TODO why have both a named and unnamed constructor? Let's decide which one to use
  User.constructor(this.id, this.name, this.surname, this.imageUrl, this.email);
}

@immutable
class UserSession {
  final User user;
  final String provider;
  final Credentials credentials;

  UserSession(
      {@required this.user,
        @required this.provider,
        @required this.credentials});

  UserSession.constructor(this.user, this.provider, this.credentials);
}

@freezed
abstract class UserID with _$UserID {
  const factory UserID(String id) = _UserID;
}

@immutable
class Credentials {
  final String _token;

  Credentials._constructor(this._token);

  static Credentials Function(String tokenString) constructorFunction =
      (token) => Credentials._constructor(token);

  // RESEARCH Can extension methods be used as a static function and method at the same time like C#? Can something similar be done with constructors?
  Map<String, String> get toAuthHeader => {"Authorization": _token};

  static Credentials Function(String tokenString) bearerFromToken =
      (token) => Credentials._constructor("Bearer $token");
}

@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState(UserSession session) = SignedIn;
  const factory SignInState.anonymous() = Anonymous;
}

extension SignInStateOps on SignInState {
  Option<UserSession> get userSession =>
      this.maybeWhen((session) => Some(session), orElse: () => none());
}
