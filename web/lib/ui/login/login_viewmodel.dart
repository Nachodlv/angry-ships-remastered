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

  init() {
    _authenticationService.userStateChangeStream
      .listen((data) => _setUserState(data));
  }  

  signInWithGoogle() async {
    try {
      await _authenticationService.signInWithGoogle();
    } catch (e) {
      print(e);
    }
  }

  signOut() {
    try {
      _authenticationService.signOut();
    } catch (e) {
      print(e);
    }
  }

  void _setUserState(RemoteData<String, SignInState> state) {
    userState = state;
    notifyListeners();
  }
}