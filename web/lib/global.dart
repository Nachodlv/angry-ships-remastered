import 'package:web/services/auth/auth_service.dart';
import 'package:web/services/auth/auth_service_firebase.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<NavigationService>(NavigationService());
  locator.registerSingleton<AuthenticationService>(AuthenticationServiceFirebase()); 
}