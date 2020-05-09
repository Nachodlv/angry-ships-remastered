import 'package:web/global.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:web/services/navigation/router.dart';

void main() {
  setupLocator();
  runApp(App());
}

ThemeData AngryShipsTheme(BuildContext context) => ThemeData(
  textTheme: Theme.of(context).textTheme.apply(
    fontFamily: 'Poppins',
  ),
);

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Angry Ships',
      color: Colors.white,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: Routes.LOAD,
      theme: AngryShipsTheme(context),
    );
  }
}
