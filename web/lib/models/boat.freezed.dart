// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'boat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$BoatTearOff {
  const _$BoatTearOff();

  _Boat call(
      {int shoots,
      int rotationIndex,
      bool sunken,
      Point pivot,
      List<Point> points,
      BoatType boatType}) {
    return _Boat(
      shoots: shoots,
      rotationIndex: rotationIndex,
      sunken: sunken,
      pivot: pivot,
      points: points,
      boatType: boatType,
    );
  }
}

// ignore: unused_element
const $Boat = _$BoatTearOff();

mixin _$Boat {
  int get shoots;
  int get rotationIndex;
  bool get sunken;
  Point get pivot;
  List<Point> get points;
  BoatType get boatType;

  Map<String, dynamic> toJson();
  $BoatCopyWith<Boat> get copyWith;
}

abstract class $BoatCopyWith<$Res> {
  factory $BoatCopyWith(Boat value, $Res Function(Boat) then) =
      _$BoatCopyWithImpl<$Res>;
  $Res call(
      {int shoots,
      int rotationIndex,
      bool sunken,
      Point pivot,
      List<Point> points,
      BoatType boatType});
}

class _$BoatCopyWithImpl<$Res> implements $BoatCopyWith<$Res> {
  _$BoatCopyWithImpl(this._value, this._then);

  final Boat _value;
  // ignore: unused_field
  final $Res Function(Boat) _then;

  @override
  $Res call({
    Object shoots = freezed,
    Object rotationIndex = freezed,
    Object sunken = freezed,
    Object pivot = freezed,
    Object points = freezed,
    Object boatType = freezed,
  }) {
    return _then(_value.copyWith(
      shoots: shoots == freezed ? _value.shoots : shoots as int,
      rotationIndex: rotationIndex == freezed
          ? _value.rotationIndex
          : rotationIndex as int,
      sunken: sunken == freezed ? _value.sunken : sunken as bool,
      pivot: pivot == freezed ? _value.pivot : pivot as Point,
      points: points == freezed ? _value.points : points as List<Point>,
      boatType: boatType == freezed ? _value.boatType : boatType as BoatType,
    ));
  }
}

abstract class _$BoatCopyWith<$Res> implements $BoatCopyWith<$Res> {
  factory _$BoatCopyWith(_Boat value, $Res Function(_Boat) then) =
      __$BoatCopyWithImpl<$Res>;
  @override
  $Res call(
      {int shoots,
      int rotationIndex,
      bool sunken,
      Point pivot,
      List<Point> points,
      BoatType boatType});
}

class __$BoatCopyWithImpl<$Res> extends _$BoatCopyWithImpl<$Res>
    implements _$BoatCopyWith<$Res> {
  __$BoatCopyWithImpl(_Boat _value, $Res Function(_Boat) _then)
      : super(_value, (v) => _then(v as _Boat));

  @override
  _Boat get _value => super._value as _Boat;

  @override
  $Res call({
    Object shoots = freezed,
    Object rotationIndex = freezed,
    Object sunken = freezed,
    Object pivot = freezed,
    Object points = freezed,
    Object boatType = freezed,
  }) {
    return _then(_Boat(
      shoots: shoots == freezed ? _value.shoots : shoots as int,
      rotationIndex: rotationIndex == freezed
          ? _value.rotationIndex
          : rotationIndex as int,
      sunken: sunken == freezed ? _value.sunken : sunken as bool,
      pivot: pivot == freezed ? _value.pivot : pivot as Point,
      points: points == freezed ? _value.points : points as List<Point>,
      boatType: boatType == freezed ? _value.boatType : boatType as BoatType,
    ));
  }
}

@JsonSerializable()
class _$_Boat with DiagnosticableTreeMixin implements _Boat {
  _$_Boat(
      {this.shoots,
      this.rotationIndex,
      this.sunken,
      this.pivot,
      this.points,
      this.boatType});

  @override
  final int shoots;
  @override
  final int rotationIndex;
  @override
  final bool sunken;
  @override
  final Point pivot;
  @override
  final List<Point> points;
  @override
  final BoatType boatType;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Boat(shoots: $shoots, rotationIndex: $rotationIndex, sunken: $sunken, pivot: $pivot, points: $points, boatType: $boatType)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Boat'))
      ..add(DiagnosticsProperty('shoots', shoots))
      ..add(DiagnosticsProperty('rotationIndex', rotationIndex))
      ..add(DiagnosticsProperty('sunken', sunken))
      ..add(DiagnosticsProperty('pivot', pivot))
      ..add(DiagnosticsProperty('points', points))
      ..add(DiagnosticsProperty('boatType', boatType));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Boat &&
            (identical(other.shoots, shoots) ||
                const DeepCollectionEquality().equals(other.shoots, shoots)) &&
            (identical(other.rotationIndex, rotationIndex) ||
                const DeepCollectionEquality()
                    .equals(other.rotationIndex, rotationIndex)) &&
            (identical(other.sunken, sunken) ||
                const DeepCollectionEquality().equals(other.sunken, sunken)) &&
            (identical(other.pivot, pivot) ||
                const DeepCollectionEquality().equals(other.pivot, pivot)) &&
            (identical(other.points, points) ||
                const DeepCollectionEquality().equals(other.points, points)) &&
            (identical(other.boatType, boatType) ||
                const DeepCollectionEquality()
                    .equals(other.boatType, boatType)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(shoots) ^
      const DeepCollectionEquality().hash(rotationIndex) ^
      const DeepCollectionEquality().hash(sunken) ^
      const DeepCollectionEquality().hash(pivot) ^
      const DeepCollectionEquality().hash(points) ^
      const DeepCollectionEquality().hash(boatType);

  @override
  _$BoatCopyWith<_Boat> get copyWith =>
      __$BoatCopyWithImpl<_Boat>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

abstract class _Boat implements Boat {
  factory _Boat(
      {int shoots,
      int rotationIndex,
      bool sunken,
      Point pivot,
      List<Point> points,
      BoatType boatType}) = _$_Boat;

  @override
  int get shoots;
  @override
  int get rotationIndex;
  @override
  bool get sunken;
  @override
  Point get pivot;
  @override
  List<Point> get points;
  @override
  BoatType get boatType;
  @override
  _$BoatCopyWith<_Boat> get copyWith;
}
