import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/chat_state_provider.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'back_end_service.dart';
import 'package:front_travelbuddy/services/firestore_service.dart';
import 'package:front_travelbuddy/change_notifiers/fire_base_stream_provider.dart';

class AuthService {
  //For accessing firebaseAuth
  final Spinner spinner;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authStateSubscription; // ignore: unused_field
  UserModel userModel;
  BackEndService backEndService;
  FireStoreService fireStoreService;
  FireStoreStreamProvider fireStoreStreamProvider;

  AuthService({required this.spinner, required this.backEndService, required this.userModel, required this.fireStoreService, required this.fireStoreStreamProvider}) {
    // Sets up Auth + starts to listen for auth changes
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
          userModel.setUser('none');
          print('No user signed in!');
        } else {
          userModel.setUser(user.uid);
          fireStoreService.getAndSetChatroomAtIndex(chatroomIndex: 0);
          
          final userID = user.uid;
          print('User Change signalled - UserID: $userID');
          // Additional actions for sign-in (e.g., fetch user profile)
        }
      },
    );
  }

  Future<UserCredential?> createUserWithEmailAndPassword({
    // Create user profile on google Auth. and sends vertification request. Does not yet create profile on DB
    required String userEmail,
    required String userPassword,
    required Function() emailVerificationPopUp,
  }) async {
    dynamic newUserCred;
    try {
      newUserCred = await _auth.createUserWithEmailAndPassword(email: userEmail, password: userPassword);
      _auth.currentUser?.sendEmailVerification();
      emailVerificationPopUp();
      await _auth.signOut();
      return newUserCred;
    } catch (e) {
      print('error: $e');
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle({Function? nextScreenCall}) async {
    // Signs in with google and sends request to backend to create user profile if 1st time SignIn.
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
    googleProvider.addScope('https://www.googleapis.com/auth/userinfo.profile');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    try {
      var userCred = await _auth.signInWithPopup(googleProvider);

      if (userCred.additionalUserInfo!.isNewUser) {
        print("Is new user");
        spinner.showSpinner();
        await backEndService.addNewUser(userCred: userCred);

        spinner.hideSpinner();
      } else {}

      // Log in succesfull and create new user succesfull
      fireStoreStreamProvider.userChangeStreamUpdate();
      nextScreenCall?.call();
      return userCred;
    } on Exception catch (e) {
      spinner.hideSpinner();
      print('error: $e');
      return null;
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String userEmail,
    required String userPassword,
    required Function() emailVerificationPopUp,
    Function? nextScreenCall,
  }) async {
    // Checks if user email is verified. Also checks if user profile exists on DB.
    //if not, sends request to backend to add new user. This is for first time sign in.

    try {
      spinner.showSpinner();
      var userCred = await _auth.signInWithEmailAndPassword(email: userEmail, password: userPassword);
      bool emailVerified = userCred.user!.emailVerified;

      if (emailVerified) {
        if (await fireStoreService.doesUserProfileExist(userCred.user!.uid)) {
          print('Checked if user profile exists');
          fireStoreStreamProvider.userChangeStreamUpdate();
          spinner.hideSpinner();
          nextScreenCall?.call();
        } else {
          await backEndService.addNewUser(userCred: userCred);
          fireStoreStreamProvider.userChangeStreamUpdate();
          spinner.hideSpinner();
          nextScreenCall?.call();
        }
      } else {
        spinner.hideSpinner();
        emailVerificationPopUp();
        await _auth.currentUser!.sendEmailVerification();
        _auth.signOut();
      }
    } on Exception catch (e) {
      spinner.hideSpinner();
      print(e);
    }
  }

  Future<void> resetPassword({required String userEmail}) async {
    try {
      await _auth.sendPasswordResetEmail(email: userEmail);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut(VoidCallback nextScreenCall) async {
    try {
      await _auth.signOut();
      fireStoreStreamProvider.userChangeStreamUpdate();
      nextScreenCall();
      print('signed out');
    } catch (e) {
      print(e);
    }
  }
}
