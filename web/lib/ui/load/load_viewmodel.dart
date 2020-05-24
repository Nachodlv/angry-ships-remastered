import 'package:flutter/foundation.dart';
import 'package:web/global.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:web/services/navigation/navigation_routes.dart';


class LoadViewModel extends ChangeNotifier {

  NavigationService _navigationService = locator<NavigationService>();
  
  init() async {
    await Future.delayed(const Duration(seconds: 2))
      .whenComplete(() => _navigationService.navigateTo(Routes.LOGIN));
  }
}