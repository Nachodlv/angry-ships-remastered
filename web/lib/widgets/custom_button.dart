import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final double fontSize;
  final bool disabled;

  CustomButton(this.text, {Function onPressed, this.fontSize = 20, this.disabled = false})
      : onPressed = onPressed ?? (() {});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: !disabled ? onPressed : null,
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize),
      ),
      color: Colors.blue[300],
    );
  }
}
