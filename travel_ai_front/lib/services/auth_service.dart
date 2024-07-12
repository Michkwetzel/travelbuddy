import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_ai_front/state/spinner.dart';

class AuthService {
  final FirebaseAuth _auth;

  final Spinner _spinner;

  AuthService({FirebaseAuth? auth, required Spinner spinner})
      : _auth = auth ?? FirebaseAuth.instance,
        _spinner = spinner;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      _spinner.showSpinner();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth != null && (googleAuth.accessToken != null || googleAuth.idToken != null)) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCred = await FirebaseAuth.instance.signInWithCredential(credential);
        _spinner.hideSpinner();
        return userCred;
      } else {
        _spinner.hideSpinner();
        print("Sign in Cancelled");
        return null;
      }
    } on Exception catch (e) {
      _spinner.hideSpinner();
      print(e);
      return null;
    }
  }

  FirebaseAuth getAuthInstance() {
    return _auth;
  }

  Future<UserCredential?> signInWithEmailAndPassword(String userEmail, String userPassword) async {
    try {
      _spinner.showSpinner();
      var userCred = await _auth.signInWithEmailAndPassword(email: userEmail, password: userPassword);
      _spinner.hideSpinner();
      return userCred;
    } on Exception catch (e) {
      _spinner.hideSpinner();
      print(e);
      if (true) {
        print("re");
      }
      return null;
    }
  }
}

class Hi {}
