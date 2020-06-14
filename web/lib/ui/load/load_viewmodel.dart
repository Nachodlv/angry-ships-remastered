import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:web/data_structures/remote_data.dart';
import 'package:web/global.dart';
import 'package:web/models/auth.dart';
import 'package:web/services/auth/auth_service.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/user/user_service.dart';
import 'package:web/ui/home/home_view.dart';

class LoadViewModel extends ChangeNotifier {
  RemoteData<String, SignInState> userState = RemoteData.notAsked();

  StreamSubscription<RemoteData<String, SignInState>> onUserStateChange;
  
  NavigationService _navigationService = locator<NavigationService>();
  AuthenticationService _authenticationService = locator<AuthenticationService>();
  UserService _userService = locator<UserService>();

  init(BuildContext context) async {
    onUserStateChange = _authenticationService.userStateChangeStream.listen((data) {
      _setUserState(data);
      data.maybeWhen(
          success: (state) =>
              state.maybeWhen((session) => _retrieveUser(session), orElse: () {
              }),
          notAsked: () {
            _navigationService.navigateTo(Routes.LOGIN);
          },
          orElse: () {
          });
    });
    _signInWithGoogleSilently();
  }

  _signInWithGoogleSilently() async {
    try {
      await _authenticationService.signInSilentlyWithGoogle();
    } catch (e) {
      print(e);
    }
  }

  void _setUserState(RemoteData<String, SignInState> state) {
    userState = state;
    notifyListeners();
  }

  _retrieveUser(UserSession session) async {
    try {
      await _userService.createUser(session.credentials.token);
    } catch (e) {
      print(e); // TODO Handle error
    }

    final user = await _userService.getUser(
        session.user.id.id, session.credentials.token);
    _navigationService.navigateTo(Routes.HOME,
        arguments: HomeViewArguments(
            userCredentials: session.credentials, userId: user.id.id));
  }
  
  @override
  void dispose() {
    onUserStateChange.cancel();
    super.dispose();
  }
}
