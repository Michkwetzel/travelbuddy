import 'package:flutter/material.dart';

class ChatStateProvider with ChangeNotifier{
  String _currentChatroomID = '';
  String _currentChatroomName = '';
  bool _newChatValid = true;

  bool get newChatValid => _newChatValid;
  String get currentChat => _currentChatroomID;
  String get currentChatroomName => _currentChatroomName;

  void setCurrentChatroom(String chatroomID){
    _currentChatroomID = chatroomID;
    notifyListeners();
  }

  void setCurrentChatroomName(String chatroomName){
    _currentChatroomName = chatroomName;
    notifyListeners();
  }


  void setValidTrue(){  
    _newChatValid = true;
  }

  void setValidFalse(){
    _newChatValid = false;
  }

}