import 'package:web/global.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:web/services/navigation/router.dart';
import 'package:web/ui/room/boat_placement/boat_placement_view.dart';
import 'package:web/ui/room/shoot/shoot_view.dart';

void main() async {
  runApp(Locator());
}

ThemeData angryShipsTheme(BuildContext context) => ThemeData(
      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Teko',
          ),
    );

class Locator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setupLocator(context),
      builder: (context, snapshot) {
        print('Has data: ${snapshot.hasData}, data: ${snapshot.data}');
        return snapshot.hasData ? App() : Container();
      },
    );
  }
}

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
//    return MaterialApp(
//      builder: (_, __) => Scaffold(
//        backgroundColor: Colors.blue[300],
//          body: ShootView(
//              arguments: ShootViewArguments(
//                  socket: null, firstTurn: true, boats: []))),
//    );
  }
}
