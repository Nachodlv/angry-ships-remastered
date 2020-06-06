import 'dart:async';

import 'package:flutter/cupertino.dart';

class Countdown extends StatefulWidget {
  final Duration duration;
  final Function onFinish;
  
  Countdown({@required this.duration, this.onFinish});
  
  @override
  State<StatefulWidget> createState() {
    return _CountdownState();
  }
}

class _CountdownState extends State<Countdown> {
  Duration currentDuration;
  
  
  @override
  void initState() {
    super.initState();
    print("Duration: ${widget.duration.toString()}");
    currentDuration = widget.duration;
    int lastCall = DateTime.now().millisecondsSinceEpoch;
    Timer.periodic(Duration(seconds: 1), (timer) { 
      int deltaTime = DateTime.now().millisecondsSinceEpoch - lastCall;
      currentDuration -= Duration(milliseconds: deltaTime);
      if(currentDuration.inSeconds <= 0) {
        timer.cancel();
        currentDuration = Duration(seconds: 0);
        widget.onFinish?.call();
      }
      setState(() {
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Text(currentDuration.inSeconds.toString());
  }
  
}