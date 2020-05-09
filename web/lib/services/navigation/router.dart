import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web/ui/load/load_view.dart';
import 'package:web/ui/login/login_view.dart';

import 'navigation_routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.LOAD:
      return MaterialPageRoute(builder: (context) => LoadView());
    case Routes.LOGIN:
      return MaterialPageRoute(builder: (context) => LoginView());
    // TODO Default to home
  }
}
