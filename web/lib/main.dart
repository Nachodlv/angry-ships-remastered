import 'package:web/global.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:web/services/navigation/router.dart';
import 'package:web/ui/room/boat_placement/boat_placement_view.dart';
void main() async {
  await setupLocator();
  runApp(App());
}

ThemeData angryShipsTheme(BuildContext context) => ThemeData(
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
        onGenerateRoute: RoutesGenerator.onGenerateRoute,
        initialRoute: Routes.LOAD,
        theme: angryShipsTheme(context));
  }
}


