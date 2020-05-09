import 'package:web/data_structures/remote_data.dart';
import 'package:web/global.dart';
import 'package:web/models/auth.dart';
import 'package:web/services/auth/auth_service.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  NavigationService _navigationService = locator<NavigationService>();
  AuthenticationService _authenticationService = locator<AuthenticationService>();

  init() {

  }

  signInWithGoogle() async => await _authenticationService.signInWithGoogle();

  RemoteData<String, SignInState> get userState => _authenticationService.userState;
}