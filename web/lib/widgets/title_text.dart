import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double textSize;

  TitleText(this.text, {this.textSize = 30});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize, color: Colors.white),);
  }
  
}