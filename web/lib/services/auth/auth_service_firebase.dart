import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:web/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:web/data_structures/remote_data.dart';
import 'package:web/models/auth.dart';

class AuthenticationServiceFirebase implements AuthenticationService {
  RemoteData<String, SignInState> userState = RemoteData.notAsked();

  FirebaseAuth _auth;
  final StreamController<RemoteData<String, SignInState>>
  _userStateChangeController = StreamController.broadcast();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  AuthenticationServiceFirebase(FirebaseApp app){
    _auth = FirebaseAuth.fromApp(app);
  }
  
  @override
  Future<SignInState> signInSilentlyWithGoogle() async {
    _setUserState(RemoteData.loading());
    GoogleSignInAccount signInAccount = await googleSignIn.signInSilently(suppressErrors: true);
    return await _login(signInAccount, suppressErrors: true);
  }

  // TODO No err handling
  @override
  Future<SignInState> signInWithGoogle() async {
    _setUserState(RemoteData.loading());
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    return await _login(googleSignInAccount);
  }

  @override
  Future<void> signOut() async {
    if (userState.isSuccess) {
      userState.maybeWhen(
          success: (SignInState state) {
            state.maybeWhen((session) async {
              await _signOutByGivenProviderId(session.provider);
              userState = RemoteData.success(SignInState.anonymous());
              _userStateChangeController.add(userState);
            }, orElse: () {});
          },
          orElse: () {});
    }
  }

  @override
  bool get isSignedIn => userState.maybeWhen(
      success: (state) =>
          state.maybeWhen((ignore) => true, orElse: () => false),
      orElse: () => false);

  @override
  Stream<SignInState> get sessionChangeStream => _userStateChangeController
      .stream
      .where((ev) => ev.isSuccess)
      .map((ev) => ev.maybeWhen(
      orElse: () => SignInState.anonymous(), success: (s) => s));

  @override
  Stream<RemoteData<String, SignInState>> get userStateChangeStream =>
      _userStateChangeController.stream;

  Future<SignInState> _login(GoogleSignInAccount googleSignInAccount, {bool suppressErrors = false}) async {
    if (googleSignInAccount == null) {
      if(suppressErrors) {
        _setUserState(RemoteData.notAsked());
        return SignInState.anonymous();
      }
//      else _setUserState(RemoteData.error('Google sign in exited.'));
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    if (!user.isAnonymous) {
      _setUserState(RemoteData.error('Tried logging user but got anonymous session.'));
    }

    final FirebaseUser currentUser = await _auth.currentUser();
    if (user.uid != currentUser.uid) {
      _setUserState(RemoteData.error('User uid mismatch.'));
    }

    final tokenResult = await currentUser.getIdToken(refresh: true);
    if (tokenResult != null) {
      _setUserState(RemoteData.error('No id token received from logged user.'));
    }

    final credentials = Credentials.bearerFromToken(tokenResult.token);
    final session = _makeUserSession(currentUser, credentials);
    final signInState = SignInState(session);

    _setUserState(RemoteData.success(signInState));
    return signInState;
  }
  
  static UserSession _makeUserSession(
      FirebaseUser user, Credentials credentials) {

    return UserSession(
        user: User(
          id: UserID(user.uid),
          name: user.displayName,
          email: user.email,
          imageUrl: user.photoUrl,
        ),
        provider: user.providerId,
        credentials: credentials);
  }

  // TODO No err handling
  Future<void> _signOutByGivenProviderId(String providerId) async {
    _setUserState(RemoteData.loading());

    switch (providerId) {
      case 'firebase':
        {
          await googleSignIn.signOut();
          await googleSignIn.disconnect();
          await _auth.signOut();

          _setUserState(RemoteData.success(SignInState.anonymous()));
        }
    }
  }

  @override
  Future<void> init() async {
    final FirebaseUser user = await _auth.currentUser();

    if(user != null) {
      final idToken = await user.getIdToken(refresh: true);
      final Credentials credentials = Credentials.bearerFromToken(idToken.token);
      final session = _makeUserSession(user, credentials);

      _setUserState(RemoteData.success(SignInState(session)));
    } else {
      _setUserState(RemoteData.success(SignInState.anonymous()));
    }
  }

  void _setUserState(RemoteData<String, SignInState> remoteData) {
    userState = remoteData;
    _userStateChangeController.add(userState);
  }
}
