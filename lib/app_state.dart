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

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  SharedPreferences get prefs => _prefs;

  Future<void> initializeState() async {
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn = await isUserLoggedIn();
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

  bool get isInitialized => _prefs != null;

  Future<bool> isUserLoggedIn() async {
    String phone = _prefs.getString('phone') ?? '';
    String password = _prefs.getString('password') ?? '';
    return phone.isNotEmpty && password.isNotEmpty;
  }

  Future<void> login(String phone, String password) async {
    await _prefs.setString('phone', phone);
    await _prefs.setString('password', password);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _prefs.remove('phone');
    await _prefs.remove('password');
    _isLoggedIn = false;
    notifyListeners();
  }
}
