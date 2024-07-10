import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String user = "";

  void setUser(String currentUser){
    user = currentUser;
    notifyListeners(); 
  }
}
