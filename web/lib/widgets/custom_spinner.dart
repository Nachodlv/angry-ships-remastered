import 'package:flutter/material.dart';

class CustomSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      backgroundColor: Colors.blue[300],
    );
  }
  
}