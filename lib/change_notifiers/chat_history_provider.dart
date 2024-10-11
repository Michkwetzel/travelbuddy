import 'package:flutter/material.dart';

class ChatHistoryProvider with ChangeNotifier{
  List<String> _chatHistory = [];

  List<String> get chatHistory => _chatHistory;

  void setHistory(List<String> history){
    _chatHistory = history;
  }

}