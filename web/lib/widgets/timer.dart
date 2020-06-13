import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:web/widgets/title_text.dart';

class CountDownController {
  _CountdownState countdownState;
  
  resetCountdown() {
    countdownState?.resetCountdown();
  }
}

class Countdown extends StatefulWidget {
  final Duration duration;
  final Function onFinish;
  final CountDownController controller;
  
  Countdown({@required this.duration, this.onFinish, CountDownController controller, Key key}): 
        controller = controller ?? CountDownController(), super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return _CountdownState(controller);
  }
  
}

class _CountdownState extends State<Countdown> {
  Duration _currentDuration;
  Timer _timer;
  final CountDownController controller;
  
  _CountdownState(this.controller) {
    controller.countdownState = this;
  }
  
  @override
  void initState() {
    super.initState();
    _startCountdown();
  }
  
  @override
  Widget build(BuildContext context) {
    return TitleText(_currentDuration.inSeconds.toString(), textSize: 25,);
  }
  
  resetCountdown() {
    if(_timer != null) _timer.cancel();
    _startCountdown();
  }
  
  _startCountdown() {
    _currentDuration = widget.duration;
    int lastCall = DateTime.now().microsecondsSinceEpoch;
    final interval = Duration(seconds: 1);
    _timer = Timer.periodic(interval, (timer) {
      _currentDuration -= interval;
      if(_currentDuration.inSeconds <= 0) {
        timer.cancel();
        _currentDuration = Duration(seconds: 0);
        widget.onFinish?.call();
      }
      setState(() {
      });
    });
  }
  
  @override
  void dispose() {
    controller.countdownState = null;
    _timer?.cancel();
    super.dispose();
  }
  
}