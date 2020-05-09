import 'package:flutter/widgets.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future navigateTo(String routeName, {arguments}) {
    return _navigatorKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  @override
  bool goBack() {
    _navigatorKey.currentState.pop();
    return true;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
}