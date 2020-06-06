  import 'package:flutter/widgets.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future navigateTo(String routeName, {arguments}) {
    if(_navigatorKey.currentState.canPop())
      return _navigatorKey.currentState
          .pushReplacementNamed(routeName, arguments: arguments);
    else return _navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

//  Future navigateTo(String routeName, {arguments}) {
//    return _navigatorKey.currentState
//        .pushNamed(routeName, arguments: arguments);
//  }

  @override
  bool goBack() {
    _navigatorKey.currentState.pop();
    return true;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
}