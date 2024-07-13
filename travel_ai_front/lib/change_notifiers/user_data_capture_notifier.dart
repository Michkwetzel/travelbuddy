import 'package:flutter/material.dart';
import 'package:travel_ai_front/state_files/user_data_capture.dart';

class UserDataCaptureNotifier with ChangeNotifier {
  UserDataCapture _userData = UserDataCapture();

  UserDataCapture get userData => _userData;

  void updateUserDataCapture(String field, String value) {
    switch (field) {
      case "Name":
        _userData.name = value;
      case "surname":
        _userData.name = value;
      case "passport":
        _userData.name = value;
      case "destination":
        _userData.name = value;
      case "age":
        _userData.name = value;
      case "travelBudget":
        _userData.name = value;
    }
    notifyListeners();
  }
}