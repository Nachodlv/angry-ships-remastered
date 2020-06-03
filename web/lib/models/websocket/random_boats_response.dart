import '../boat.dart';

class RandomBoatsResponse {
  final List<Boat> boatsWithErrors;
  final List<Boat> boats;

  RandomBoatsResponse(this.boatsWithErrors, this.boats);

  factory RandomBoatsResponse.fromJson(Map<String, dynamic> json) {
    return RandomBoatsResponse(
      List<dynamic>.from(json['boatsWithErrors']).map((p) => Boat.fromJson(p)).toList(), 
      List<dynamic>.from(json['boats']).map((p) => Boat.fromJson(p)).toList(),);
  }
}