import 'package:web/data_structures/remote_data.dart';
import 'package:web/global.dart';
import 'package:web/models/auth.dart';
import 'package:web/services/auth/auth_service.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  RemoteData<String, SignInState> userState = RemoteData.notAsked();

  NavigationService _navigationService = locator<NavigationService>();
  AuthenticationService _authenticationService = locator<AuthenticationService>();

  init() {}

  signInWithGoogle() async {
    _setUserState(RemoteData.loading());

    try {
      final state = await _authenticationService.signInWithGoogle();
      _setUserState(RemoteData.success(state));
    } catch (e) {
      _setUserState(RemoteData.error(e));
    }
  }

  void _setUserState(RemoteData<String, SignInState> state) {
    userState = state;
    notifyListeners();
  }
}