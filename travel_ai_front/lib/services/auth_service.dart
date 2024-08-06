import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:travel_ai_front/change_notifiers/spinner.dart';
import 'package:travel_ai_front/change_notifiers/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // ignore: unused_field
  StreamSubscription<User?>? _authStateSubscription;
  UserModel _userModel; // Store the subscription

  final Spinner _spinner;

  AuthService({required spinner, required userModel})
      : _spinner = spinner,
        _userModel = userModel {
    _listenForAuthChanges();
  }

  FirebaseAuth getAuthInstance() {
    return _auth;
  }

  void _listenForAuthChanges() {
    _authStateSubscription = _auth.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          _userModel.setUser('none');
          print('User is currently signed out!');
          // Additional actions for sign-out (e.g., clear user data)
        } else {
          _userModel.setUser(user.uid);
          final userDisplayName = user.displayName;
          final userUID = user.uid;
          print('User Name: $userDisplayName , UserUID: $userUID');
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
        nextScreen();
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
