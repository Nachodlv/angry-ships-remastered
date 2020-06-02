import 'dart:math';
import 'package:web/global.dart';
import 'dart:ui';

String generateRandomId() {
  final randomDouble = Random().nextDouble() * 1000000000000000;
  return "${randomDouble.floor()}";
}

double calculateTileSide(Size contextSize) {
  final fieldArea = contextSize.width * contextSize.height;
  final tileSide = sqrt(fieldArea / kTilesQuantity);
  return tileSide;
}