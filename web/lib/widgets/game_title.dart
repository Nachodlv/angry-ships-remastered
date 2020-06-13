import 'package:flutter/material.dart';

class GameTitle extends StatelessWidget {
  final double fontSize;


  GameTitle({this.fontSize = 200});

  @override
  Widget build(BuildContext context) {
    return Text(
      'ANGRY SHIPS\nREMASTERED',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: 'Teko',
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          height: 1,
          color: Colors.white),
    );
  }
  
}