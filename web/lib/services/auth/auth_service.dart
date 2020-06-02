import 'package:web/models/auth.dart';
import 'package:web/data_structures/remote_data.dart';

abstract class AuthenticationService {
  Future<void> init();
  RemoteData<String, SignInState> get userState;
  Future<SignInState> signInWithGoogle();
  Future<SignInState> signInSilentlyWithGoogle();
  Future<void> signOut();
  Stream<SignInState> get sessionChangeStream;
  Stream<RemoteData<String, SignInState>> get userStateChangeStream;
  bool get isSignedIn;
}

