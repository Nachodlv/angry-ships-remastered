// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'remote_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$RemoteDataTearOff {
  const _$RemoteDataTearOff();

  Success<E, A> success<E, A>(A value) {
    return Success<E, A>(
      value,
    );
  }

  Error<E, A> error<E, A>(E error) {
    return Error<E, A>(
      error,
    );
  }

  Loading<E, A> loading<E, A>() {
    return Loading<E, A>();
  }

  Unasked<E, A> notAsked<E, A>() {
    return Unasked<E, A>();
  }
}

// ignore: unused_element
const $RemoteData = _$RemoteDataTearOff();

mixin _$RemoteData<E, A> {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result success(A value),
    @required Result error(E error),
    @required Result loading(),
    @required Result notAsked(),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result success(A value),
    Result error(E error),
    Result loading(),
    Result notAsked(),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result success(Success<E, A> value),
    @required Result error(Error<E, A> value),
    @required Result loading(Loading<E, A> value),
    @required Result notAsked(Unasked<E, A> value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result success(Success<E, A> value),
    Result error(Error<E, A> value),
    Result loading(Loading<E, A> value),
    Result notAsked(Unasked<E, A> value),
    @required Result orElse(),
  });
}

abstract class $RemoteDataCopyWith<E, A, $Res> {
  factory $RemoteDataCopyWith(
          RemoteData<E, A> value, $Res Function(RemoteData<E, A>) then) =
      _$RemoteDataCopyWithImpl<E, A, $Res>;
}

class _$RemoteDataCopyWithImpl<E, A, $Res>
    implements $RemoteDataCopyWith<E, A, $Res> {
  _$RemoteDataCopyWithImpl(this._value, this._then);

  final RemoteData<E, A> _value;
  // ignore: unused_field
  final $Res Function(RemoteData<E, A>) _then;
}

abstract class $SuccessCopyWith<E, A, $Res> {
  factory $SuccessCopyWith(
          Success<E, A> value, $Res Function(Success<E, A>) then) =
      _$SuccessCopyWithImpl<E, A, $Res>;
  $Res call({A value});
}

class _$SuccessCopyWithImpl<E, A, $Res>
    extends _$RemoteDataCopyWithImpl<E, A, $Res>
    implements $SuccessCopyWith<E, A, $Res> {
  _$SuccessCopyWithImpl(
      Success<E, A> _value, $Res Function(Success<E, A>) _then)
      : super(_value, (v) => _then(v as Success<E, A>));

  @override
  Success<E, A> get _value => super._value as Success<E, A>;

  @override
  $Res call({
    Object value = freezed,
  }) {
    return _then(Success<E, A>(
      value == freezed ? _value.value : value as A,
    ));
  }
}

class _$Success<E, A> with DiagnosticableTreeMixin implements Success<E, A> {
  _$Success(this.value) : assert(value != null);

  @override
  final A value;

  bool _didisLoading = false;
  bool _isLoading;

  @override
  bool get isLoading {
    if (_didisLoading == false) {
      _didisLoading = true;
      _isLoading = this.maybeWhen(loading: () => true, orElse: () => false);
    }
    return _isLoading;
  }

  bool _didisSuccess = false;
  bool _isSuccess;

  @override
  bool get isSuccess {
    if (_didisSuccess == false) {
      _didisSuccess = true;
      _isSuccess =
          this.maybeWhen(success: (ignored) => true, orElse: () => false);
    }
    return _isSuccess;
  }

  bool _didisError = false;
  bool _isError;

  @override
  bool get isError {
    if (_didisError == false) {
      _didisError = true;
      _isError = this.maybeWhen(
        error: (ignored) => true,
        orElse: () => false,
      );
    }
    return _isError;
  }

  bool _didisNotAsked = false;
  bool _isNotAsked;

  @override
  bool get isNotAsked {
    if (_didisNotAsked == false) {
      _didisNotAsked = true;
      _isNotAsked = this.maybeWhen(
        notAsked: () => true,
        orElse: () => false,
      );
    }
    return _isNotAsked;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RemoteData<$E, $A>.success(value: $value, isLoading: $isLoading, isSuccess: $isSuccess, isError: $isError, isNotAsked: $isNotAsked)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RemoteData<$E, $A>.success'))
      ..add(DiagnosticsProperty('value', value))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('isSuccess', isSuccess))
      ..add(DiagnosticsProperty('isError', isError))
      ..add(DiagnosticsProperty('isNotAsked', isNotAsked));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Success<E, A> &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(value);

  @override
  $SuccessCopyWith<E, A, Success<E, A>> get copyWith =>
      _$SuccessCopyWithImpl<E, A, Success<E, A>>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result success(A value),
    @required Result error(E error),
    @required Result loading(),
    @required Result notAsked(),
  }) {
    assert(success != null);
    assert(error != null);
    assert(loading != null);
    assert(notAsked != null);
    return success(value);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result success(A value),
    Result error(E error),
    Result loading(),
    Result notAsked(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (success != null) {
      return success(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result success(Success<E, A> value),
    @required Result error(Error<E, A> value),
    @required Result loading(Loading<E, A> value),
    @required Result notAsked(Unasked<E, A> value),
  }) {
    assert(success != null);
    assert(error != null);
    assert(loading != null);
    assert(notAsked != null);
    return success(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result success(Success<E, A> value),
    Result error(Error<E, A> value),
    Result loading(Loading<E, A> value),
    Result notAsked(Unasked<E, A> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class Success<E, A> implements RemoteData<E, A> {
  factory Success(A value) = _$Success<E, A>;

  A get value;
  $SuccessCopyWith<E, A, Success<E, A>> get copyWith;
}

abstract class $ErrorCopyWith<E, A, $Res> {
  factory $ErrorCopyWith(Error<E, A> value, $Res Function(Error<E, A>) then) =
      _$ErrorCopyWithImpl<E, A, $Res>;
  $Res call({E error});
}

class _$ErrorCopyWithImpl<E, A, $Res>
    extends _$RemoteDataCopyWithImpl<E, A, $Res>
    implements $ErrorCopyWith<E, A, $Res> {
  _$ErrorCopyWithImpl(Error<E, A> _value, $Res Function(Error<E, A>) _then)
      : super(_value, (v) => _then(v as Error<E, A>));

  @override
  Error<E, A> get _value => super._value as Error<E, A>;

  @override
  $Res call({
    Object error = freezed,
  }) {
    return _then(Error<E, A>(
      error == freezed ? _value.error : error as E,
    ));
  }
}

class _$Error<E, A> with DiagnosticableTreeMixin implements Error<E, A> {
  _$Error(this.error) : assert(error != null);

  @override
  final E error;

  bool _didisLoading = false;
  bool _isLoading;

  @override
  bool get isLoading {
    if (_didisLoading == false) {
      _didisLoading = true;
      _isLoading = this.maybeWhen(loading: () => true, orElse: () => false);
    }
    return _isLoading;
  }

  bool _didisSuccess = false;
  bool _isSuccess;

  @override
  bool get isSuccess {
    if (_didisSuccess == false) {
      _didisSuccess = true;
      _isSuccess =
          this.maybeWhen(success: (ignored) => true, orElse: () => false);
    }
    return _isSuccess;
  }

  bool _didisError = false;
  bool _isError;

  @override
  bool get isError {
    if (_didisError == false) {
      _didisError = true;
      _isError = this.maybeWhen(
        error: (ignored) => true,
        orElse: () => false,
      );
    }
    return _isError;
  }

  bool _didisNotAsked = false;
  bool _isNotAsked;

  @override
  bool get isNotAsked {
    if (_didisNotAsked == false) {
      _didisNotAsked = true;
      _isNotAsked = this.maybeWhen(
        notAsked: () => true,
        orElse: () => false,
      );
    }
    return _isNotAsked;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RemoteData<$E, $A>.error(error: $error, isLoading: $isLoading, isSuccess: $isSuccess, isError: $isError, isNotAsked: $isNotAsked)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RemoteData<$E, $A>.error'))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('isSuccess', isSuccess))
      ..add(DiagnosticsProperty('isError', isError))
      ..add(DiagnosticsProperty('isNotAsked', isNotAsked));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Error<E, A> &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @override
  $ErrorCopyWith<E, A, Error<E, A>> get copyWith =>
      _$ErrorCopyWithImpl<E, A, Error<E, A>>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result success(A value),
    @required Result error(E error),
    @required Result loading(),
    @required Result notAsked(),
  }) {
    assert(success != null);
    assert(error != null);
    assert(loading != null);
    assert(notAsked != null);
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result success(A value),
    Result error(E error),
    Result loading(),
    Result notAsked(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result success(Success<E, A> value),
    @required Result error(Error<E, A> value),
    @required Result loading(Loading<E, A> value),
    @required Result notAsked(Unasked<E, A> value),
  }) {
    assert(success != null);
    assert(error != null);
    assert(loading != null);
    assert(notAsked != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result success(Success<E, A> value),
    Result error(Error<E, A> value),
    Result loading(Loading<E, A> value),
    Result notAsked(Unasked<E, A> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error<E, A> implements RemoteData<E, A> {
  factory Error(E error) = _$Error<E, A>;

  E get error;
  $ErrorCopyWith<E, A, Error<E, A>> get copyWith;
}

abstract class $LoadingCopyWith<E, A, $Res> {
  factory $LoadingCopyWith(
          Loading<E, A> value, $Res Function(Loading<E, A>) then) =
      _$LoadingCopyWithImpl<E, A, $Res>;
}

class _$LoadingCopyWithImpl<E, A, $Res>
    extends _$RemoteDataCopyWithImpl<E, A, $Res>
    implements $LoadingCopyWith<E, A, $Res> {
  _$LoadingCopyWithImpl(
      Loading<E, A> _value, $Res Function(Loading<E, A>) _then)
      : super(_value, (v) => _then(v as Loading<E, A>));

  @override
  Loading<E, A> get _value => super._value as Loading<E, A>;
}

class _$Loading<E, A> with DiagnosticableTreeMixin implements Loading<E, A> {
  _$Loading();

  bool _didisLoading = false;
  bool _isLoading;

  @override
  bool get isLoading {
    if (_didisLoading == false) {
      _didisLoading = true;
      _isLoading = this.maybeWhen(loading: () => true, orElse: () => false);
    }
    return _isLoading;
  }

  bool _didisSuccess = false;
  bool _isSuccess;

  @override
  bool get isSuccess {
    if (_didisSuccess == false) {
      _didisSuccess = true;
      _isSuccess =
          this.maybeWhen(success: (ignored) => true, orElse: () => false);
    }
    return _isSuccess;
  }

  bool _didisError = false;
  bool _isError;

  @override
  bool get isError {
    if (_didisError == false) {
      _didisError = true;
      _isError = this.maybeWhen(
        error: (ignored) => true,
        orElse: () => false,
      );
    }
    return _isError;
  }

  bool _didisNotAsked = false;
  bool _isNotAsked;

  @override
  bool get isNotAsked {
    if (_didisNotAsked == false) {
      _didisNotAsked = true;
      _isNotAsked = this.maybeWhen(
        notAsked: () => true,
        orElse: () => false,
      );
    }
    return _isNotAsked;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RemoteData<$E, $A>.loading(isLoading: $isLoading, isSuccess: $isSuccess, isError: $isError, isNotAsked: $isNotAsked)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RemoteData<$E, $A>.loading'))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('isSuccess', isSuccess))
      ..add(DiagnosticsProperty('isError', isError))
      ..add(DiagnosticsProperty('isNotAsked', isNotAsked));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Loading<E, A>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result success(A value),
    @required Result error(E error),
    @required Result loading(),
    @required Result notAsked(),
  }) {
    assert(success != null);
    assert(error != null);
    assert(loading != null);
    assert(notAsked != null);
    return loading();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result success(A value),
    Result error(E error),
    Result loading(),
    Result notAsked(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result success(Success<E, A> value),
    @required Result error(Error<E, A> value),
    @required Result loading(Loading<E, A> value),
    @required Result notAsked(Unasked<E, A> value),
  }) {
    assert(success != null);
    assert(error != null);
    assert(loading != null);
    assert(notAsked != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result success(Success<E, A> value),
    Result error(Error<E, A> value),
    Result loading(Loading<E, A> value),
    Result notAsked(Unasked<E, A> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading<E, A> implements RemoteData<E, A> {
  factory Loading() = _$Loading<E, A>;
}

abstract class $UnaskedCopyWith<E, A, $Res> {
  factory $UnaskedCopyWith(
          Unasked<E, A> value, $Res Function(Unasked<E, A>) then) =
      _$UnaskedCopyWithImpl<E, A, $Res>;
}

class _$UnaskedCopyWithImpl<E, A, $Res>
    extends _$RemoteDataCopyWithImpl<E, A, $Res>
    implements $UnaskedCopyWith<E, A, $Res> {
  _$UnaskedCopyWithImpl(
      Unasked<E, A> _value, $Res Function(Unasked<E, A>) _then)
      : super(_value, (v) => _then(v as Unasked<E, A>));

  @override
  Unasked<E, A> get _value => super._value as Unasked<E, A>;
}

class _$Unasked<E, A> with DiagnosticableTreeMixin implements Unasked<E, A> {
  _$Unasked();

  bool _didisLoading = false;
  bool _isLoading;

  @override
  bool get isLoading {
    if (_didisLoading == false) {
      _didisLoading = true;
      _isLoading = this.maybeWhen(loading: () => true, orElse: () => false);
    }
    return _isLoading;
  }

  bool _didisSuccess = false;
  bool _isSuccess;

  @override
  bool get isSuccess {
    if (_didisSuccess == false) {
      _didisSuccess = true;
      _isSuccess =
          this.maybeWhen(success: (ignored) => true, orElse: () => false);
    }
    return _isSuccess;
  }

  bool _didisError = false;
  bool _isError;

  @override
  bool get isError {
    if (_didisError == false) {
      _didisError = true;
      _isError = this.maybeWhen(
        error: (ignored) => true,
        orElse: () => false,
      );
    }
    return _isError;
  }

  bool _didisNotAsked = false;
  bool _isNotAsked;

  @override
  bool get isNotAsked {
    if (_didisNotAsked == false) {
      _didisNotAsked = true;
      _isNotAsked = this.maybeWhen(
        notAsked: () => true,
        orElse: () => false,
      );
    }
    return _isNotAsked;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RemoteData<$E, $A>.notAsked(isLoading: $isLoading, isSuccess: $isSuccess, isError: $isError, isNotAsked: $isNotAsked)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RemoteData<$E, $A>.notAsked'))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('isSuccess', isSuccess))
      ..add(DiagnosticsProperty('isError', isError))
      ..add(DiagnosticsProperty('isNotAsked', isNotAsked));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Unasked<E, A>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result success(A value),
    @required Result error(E error),
    @required Result loading(),
    @required Result notAsked(),
  }) {
    assert(success != null);
    assert(error != null);
    assert(loading != null);
    assert(notAsked != null);
    return notAsked();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result success(A value),
    Result error(E error),
    Result loading(),
    Result notAsked(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (notAsked != null) {
      return notAsked();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result success(Success<E, A> value),
    @required Result error(Error<E, A> value),
    @required Result loading(Loading<E, A> value),
    @required Result notAsked(Unasked<E, A> value),
  }) {
    assert(success != null);
    assert(error != null);
    assert(loading != null);
    assert(notAsked != null);
    return notAsked(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result success(Success<E, A> value),
    Result error(Error<E, A> value),
    Result loading(Loading<E, A> value),
    Result notAsked(Unasked<E, A> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (notAsked != null) {
      return notAsked(this);
    }
    return orElse();
  }
}

abstract class Unasked<E, A> implements RemoteData<E, A> {
  factory Unasked() = _$Unasked<E, A>;
}
