import 'package:flutter/material.dart';

class SidePanelState extends ChangeNotifier {
  bool _isPanelVisible = true;
  bool get isPanelVisible => _isPanelVisible;

  void togglePanelState() {
    print("Ok");
    _isPanelVisible = !_isPanelVisible;
    notifyListeners();
  }
}
