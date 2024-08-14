import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';

class AuthService {
  final Spinner _spinner;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authStateSubscription; // ignore: unused_field
  UserModel _userModel;
  AuthService({required spinner, required userModel})
      // Sets up Auth + starts to listen for auth changes
      : _spinner = spinner,
        _userModel = userModel {
    _listenForAuthChanges();
  }

  FirebaseAuth getAuthInstance() {
    return _auth;
  }

  void _listenForAuthChanges() {
    // Whenever there is a change in Auth state, this method will be called
    _authStateSubscription = _auth.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          _userModel.setUser('none');
          print('No user signed in!');
        } else {
          _userModel.setUser(user.uid);
          final userUID = user.uid;
          print('UserUID: $userUID');
          print('User is signed in!');
          // Additional actions for sign-in (e.g., fetch user profile)
        }
      },
    );
  }

  Future<UserCredential?> createUserWithEmailAndPassword({required String userEmail, required String userPassword, required Function nextScreenCall}) async {
    final nextScreen = nextScreenCall;

    try {
      final newUserCred = await _auth.createUserWithEmailAndPassword(email: userEmail, password: userPassword);
      final newUserUID = newUserCred.user?.uid;
      await signInWithEmailAndPassword(userEmail, userPassword, nextScreen);
      print(newUserUID);
      return newUserCred;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle(Function nextScreenCall) async {
    final nextScreen = nextScreenCall;

    // Set up Google sing in and add scopes for email and profile information
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
    googleProvider.addScope('https://www.googleapis.com/auth/userinfo.profile');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    try {
      _spinner.showSpinner();
      var userCred = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      _spinner.hideSpinner();
      nextScreen();
      return userCred;
    } on Exception catch (e) {
      _spinner.hideSpinner();
      print(e);
      return null;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(String userEmail, String userPassword, Function nextScreenCall) async {
    final nextScreen = nextScreenCall;

    try {
      _spinner.showSpinner();
      var userCred = await _auth.signInWithEmailAndPassword(email: userEmail, password: userPassword);
      _spinner.hideSpinner();
      nextScreen();
      return userCred;
    } on Exception catch (e) {
      _spinner.hideSpinner();
      print(e);

      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('signed out');
    } catch (e) {
      print(e);
    }
  }
}
