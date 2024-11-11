import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  static void reset() {
    _instance = AppState._internal();
  }

  late SharedPreferences _prefs;

  SharedPreferences get prefs => _prefs;

  Future<void> initializeState() async {
    _prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(dateTime);
  }
}
