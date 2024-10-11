import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String _userID = 'none';

  String get currentUser {
    return _userID;
  }

  bool signedIn(){
    if (_userID == 'none') {
      return false;
    } else {
      return true;
    }
  }

  void setUser(String currentUser) {
    _userID = currentUser;
    notifyListeners();
  }
}
