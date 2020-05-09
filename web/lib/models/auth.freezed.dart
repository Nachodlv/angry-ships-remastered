// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$UserIDTearOff {
  const _$UserIDTearOff();

  _UserID call(String id) {
    return _UserID(
      id,
    );
  }
}

// ignore: unused_element
const $UserID = _$UserIDTearOff();

mixin _$UserID {
  String get id;

  $UserIDCopyWith<UserID> get copyWith;
}

abstract class $UserIDCopyWith<$Res> {
  factory $UserIDCopyWith(UserID value, $Res Function(UserID) then) =
      _$UserIDCopyWithImpl<$Res>;
  $Res call({String id});
}

class _$UserIDCopyWithImpl<$Res> implements $UserIDCopyWith<$Res> {
  _$UserIDCopyWithImpl(this._value, this._then);

  final UserID _value;
  // ignore: unused_field
  final $Res Function(UserID) _then;

  @override
  $Res call({
    Object id = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
    ));
  }
}

abstract class _$UserIDCopyWith<$Res> implements $UserIDCopyWith<$Res> {
  factory _$UserIDCopyWith(_UserID value, $Res Function(_UserID) then) =
      __$UserIDCopyWithImpl<$Res>;
  @override
  $Res call({String id});
}

class __$UserIDCopyWithImpl<$Res> extends _$UserIDCopyWithImpl<$Res>
    implements _$UserIDCopyWith<$Res> {
  __$UserIDCopyWithImpl(_UserID _value, $Res Function(_UserID) _then)
      : super(_value, (v) => _then(v as _UserID));

  @override
  _UserID get _value => super._value as _UserID;

  @override
  $Res call({
    Object id = freezed,
  }) {
    return _then(_UserID(
      id == freezed ? _value.id : id as String,
    ));
  }
}

class _$_UserID with DiagnosticableTreeMixin implements _UserID {
  const _$_UserID(this.id) : assert(id != null);

  @override
  final String id;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserID(id: $id)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserID'))
      ..add(DiagnosticsProperty('id', id));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserID &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(id);

  @override
  _$UserIDCopyWith<_UserID> get copyWith =>
      __$UserIDCopyWithImpl<_UserID>(this, _$identity);
}

abstract class _UserID implements UserID {
  const factory _UserID(String id) = _$_UserID;

  @override
  String get id;
  @override
  _$UserIDCopyWith<_UserID> get copyWith;
}

class _$SignInStateTearOff {
  const _$SignInStateTearOff();

  SignedIn call(UserSession session) {
    return SignedIn(
      session,
    );
  }

  Anonymous anonymous() {
    return const Anonymous();
  }
}

// ignore: unused_element
const $SignInState = _$SignInStateTearOff();

mixin _$SignInState {
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(UserSession session), {
    @required Result anonymous(),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(UserSession session), {
    Result anonymous(),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(SignedIn value), {
    @required Result anonymous(Anonymous value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(SignedIn value), {
    Result anonymous(Anonymous value),
    @required Result orElse(),
  });
}

abstract class $SignInStateCopyWith<$Res> {
  factory $SignInStateCopyWith(
          SignInState value, $Res Function(SignInState) then) =
      _$SignInStateCopyWithImpl<$Res>;
}

class _$SignInStateCopyWithImpl<$Res> implements $SignInStateCopyWith<$Res> {
  _$SignInStateCopyWithImpl(this._value, this._then);

  final SignInState _value;
  // ignore: unused_field
  final $Res Function(SignInState) _then;
}

abstract class $SignedInCopyWith<$Res> {
  factory $SignedInCopyWith(SignedIn value, $Res Function(SignedIn) then) =
      _$SignedInCopyWithImpl<$Res>;
  $Res call({UserSession session});
}

class _$SignedInCopyWithImpl<$Res> extends _$SignInStateCopyWithImpl<$Res>
    implements $SignedInCopyWith<$Res> {
  _$SignedInCopyWithImpl(SignedIn _value, $Res Function(SignedIn) _then)
      : super(_value, (v) => _then(v as SignedIn));

  @override
  SignedIn get _value => super._value as SignedIn;

  @override
  $Res call({
    Object session = freezed,
  }) {
    return _then(SignedIn(
      session == freezed ? _value.session : session as UserSession,
    ));
  }
}

class _$SignedIn with DiagnosticableTreeMixin implements SignedIn {
  const _$SignedIn(this.session) : assert(session != null);

  @override
  final UserSession session;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SignInState(session: $session)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SignInState'))
      ..add(DiagnosticsProperty('session', session));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SignedIn &&
            (identical(other.session, session) ||
                const DeepCollectionEquality().equals(other.session, session)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(session);

  @override
  $SignedInCopyWith<SignedIn> get copyWith =>
      _$SignedInCopyWithImpl<SignedIn>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(UserSession session), {
    @required Result anonymous(),
  }) {
    assert($default != null);
    assert(anonymous != null);
    return $default(session);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(UserSession session), {
    Result anonymous(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(session);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(SignedIn value), {
    @required Result anonymous(Anonymous value),
  }) {
    assert($default != null);
    assert(anonymous != null);
    return $default(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(SignedIn value), {
    Result anonymous(Anonymous value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class SignedIn implements SignInState {
  const factory SignedIn(UserSession session) = _$SignedIn;

  UserSession get session;
  $SignedInCopyWith<SignedIn> get copyWith;
}

abstract class $AnonymousCopyWith<$Res> {
  factory $AnonymousCopyWith(Anonymous value, $Res Function(Anonymous) then) =
      _$AnonymousCopyWithImpl<$Res>;
}

class _$AnonymousCopyWithImpl<$Res> extends _$SignInStateCopyWithImpl<$Res>
    implements $AnonymousCopyWith<$Res> {
  _$AnonymousCopyWithImpl(Anonymous _value, $Res Function(Anonymous) _then)
      : super(_value, (v) => _then(v as Anonymous));

  @override
  Anonymous get _value => super._value as Anonymous;
}

class _$Anonymous with DiagnosticableTreeMixin implements Anonymous {
  const _$Anonymous();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SignInState.anonymous()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'SignInState.anonymous'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Anonymous);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(UserSession session), {
    @required Result anonymous(),
  }) {
    assert($default != null);
    assert(anonymous != null);
    return anonymous();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(UserSession session), {
    Result anonymous(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (anonymous != null) {
      return anonymous();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(SignedIn value), {
    @required Result anonymous(Anonymous value),
  }) {
    assert($default != null);
    assert(anonymous != null);
    return anonymous(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(SignedIn value), {
    Result anonymous(Anonymous value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (anonymous != null) {
      return anonymous(this);
    }
    return orElse();
  }
}

abstract class Anonymous implements SignInState {
  const factory Anonymous() = _$Anonymous;
}
