import 'package:flutter/material.dart';

class ChatStateProvider with ChangeNotifier{
  String _currentChatroomID = '';
  bool _newChatValid = true;

  bool get newChatValid => _newChatValid;
  String get currentChat => _currentChatroomID;

  void setCurrentChatroom(String chatroomID){
    _currentChatroomID = chatroomID;
    notifyListeners();
  }

  void setValidTrue(){  
    _newChatValid = true;
  }

  void setValidFalse(){
    _newChatValid = false;
  }

}