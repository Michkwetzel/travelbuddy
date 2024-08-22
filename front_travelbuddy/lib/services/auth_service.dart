import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'db_service.dart';

class AuthService {
  final Spinner _spinner;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  StreamSubscription<User?>? _authStateSubscription; // ignore: unused_field
  UserModel _userModel;
  final dbService = DbService();

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
      _auth.signOut();
      print("Is new user");
      var userCred = await _auth.signInWithPopup(googleProvider);

      if (userCred.additionalUserInfo!.isNewUser) {
        _spinner.showSpinner();
        await dbService.addNewUser(userCred: userCred);
        _spinner.hideSpinner();
      }

      // Log in succesfull and create new user succesfull
      nextScreenCall?.call();
      return userCred;
    } on Exception catch (e) {
      _spinner.hideSpinner();
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
      _spinner.showSpinner();
      var userCred = await _auth.signInWithEmailAndPassword(email: userEmail, password: userPassword);
      bool emailVerified = userCred.user!.emailVerified;

      if (emailVerified) {
        if (await doesUserProfileExist(userCred.user!.uid)) {
          _spinner.hideSpinner();
          nextScreenCall?.call();
        } else {
          await dbService.addNewUser(userCred: userCred);
          _spinner.hideSpinner();
          nextScreenCall?.call();
        }
      } else {
        _spinner.hideSpinner();
        emailVerificationPopUp();
        await _auth.currentUser!.sendEmailVerification();
        _auth.signOut();
      }
    } on Exception catch (e) {
      _spinner.hideSpinner();
      print(e);
    }
  }

  Future<bool> doesUserProfileExist(String userUID) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(userUID).get();
      return docSnapshot.exists;
    } catch (e) {
      print('Error checking document existence: $e');
      return false;
    }
  }

  Future<void> resetPassword({required String userEmail}) async {
    try{
      await _auth.sendPasswordResetEmail(email: userEmail);
    } catch (e) {
      print(e);
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
