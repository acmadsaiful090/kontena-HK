import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  Map<String, dynamic>? _dataUser;
  Map<String, String>? _cookieData;

  Map<String, String>? get cookieData => _cookieData;

  void setCookieData(Map<String, String> newCookie) {
    _cookieData = newCookie;
    notifyListeners();
  }
  Map<String, dynamic>? get dataUser => _dataUser;
  void setDataUser(Map<String, dynamic>? newData) {
    _dataUser = newData;
    notifyListeners();
  }
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
  Map<String, dynamic>? _employeeData;

  Map<String, dynamic>? get employeeData => _employeeData;

  void setEmployeeData(Map<String, dynamic> data) {
    _employeeData = data;
    notifyListeners(); 
  }

  void clearEmployeeData() {
    _employeeData = null;
    notifyListeners();
  }
}
