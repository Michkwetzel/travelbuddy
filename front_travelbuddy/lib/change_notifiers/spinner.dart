import 'package:flutter/material.dart';

class Spinner extends ChangeNotifier {
  bool _spinner = false;

  bool get spinner {
    return _spinner;
  }

  void showSpinner() {
    _spinner = true;
    notifyListeners();
  }

  void hideSpinner() {
    _spinner = false;
    notifyListeners();
  }
}
