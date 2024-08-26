import 'package:flutter/material.dart';
import 'fire_base_stream_provider.dart';

class UserModel extends ChangeNotifier {
  String _userUID = "";

  String get currentUser {
    if (_userUID == 'none') {
      return 'No user signed in ';
    } else {
      return _userUID;
    }
  }

  bool signedIn(){
    if (_userUID == 'none') {
      return false;
    } else {
      return true;
    }
  }

  void setUser(String currentUser) {
    _userUID = currentUser;
    notifyListeners();
  }
}
