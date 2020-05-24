import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web/ui/home/home_view.dart';
import 'package:web/ui/load/load_view.dart';
import 'package:web/ui/login/login_view.dart';
import 'package:web/ui/room/room_view.dart';

import 'navigation_routes.dart';

class RoutesGenerator {
  static List<Path> paths = [
    Path(Routes.LOAD, (context, _, __) => LoadView()),
    Path(Routes.LOGIN, (context, _, __) => LoginView()),
    Path(Routes.HOME, (context, _, arguments) => HomeView(arguments as HomeViewArguments)),
    Path(Routes.ROOM, (context, _, arguments) => RoomView(arguments as RoomViewArguments)),
  ];

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    for (Path path in paths) {
      final regExpPattern = RegExp(path.pattern);
      if (regExpPattern.hasMatch(settings.name)) {
        final firstMatch = regExpPattern.firstMatch(settings.name);
        final match = (firstMatch.groupCount == 1) ? firstMatch.group(1) : null;
        return MaterialPageRoute<void>(
          builder: (context) => path.builder(context, match, settings.arguments),
          settings: settings,
        );
      }
    }
    // If no match is found, [WidgetsApp.onUnknownRoute] handles it.
    return null;
  }
}

class Path {
  final String pattern;
  final Widget Function(BuildContext, String, dynamic) builder;

  Path(this.pattern, this.builder);
}
