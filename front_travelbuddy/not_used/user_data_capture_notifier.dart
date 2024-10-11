import 'package:flutter/material.dart';
import 'state_files/user_data_capture.dart';

class UserDataCaptureNotifier with ChangeNotifier {
  UserDataCapture _userData = UserDataCapture();

  UserDataCapture get userData => _userData;

  void updateUserDataCapture(String field, String value) {
    switch (field) {
      case "name":
        _userData.name = value;
      case "surname":
        _userData.surname = value;
      case "passport":
        _userData.passport = value;
      case "destination":
        _userData.destination = value;
      case "age":
        _userData.age = value;
      case "travelBudget":
        _userData.travelBudget = value;
    }
    notifyListeners();
  }
}