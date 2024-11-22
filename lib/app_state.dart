import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static AppState _instance = AppState._internal();
  late SharedPreferences prefs;

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  static void reset() {
    _instance = AppState._internal();
  }

  Future<void> initializeState() async {
    prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _company='';
  String get company=>_company;
  set company(String value){
    _company=value;
    prefs.setString('ff_company',value);
  }
  // String _domain = 'https://erp.hotelkontena.com';
  String _domain = 'https://erp2.hotelkontena.com';

  String get domain => _domain;
  set domain(String _value) {
    _domain = _value;
  }

  String _version = '1.0.0';
  String get version => _version;
  set version(String _value) {
    _version = _value;
    prefs.setString('ff_version', _value);
  }

  String _cookieData = '';
  String get cookieData => _cookieData;
  set cookieData(String value) {
    _cookieData = value;
  }

  Map<String, dynamic> _dataUser = {};
  Map<String, dynamic> get dataUser => _dataUser;
  set dataUser(Map<String, dynamic> value) {
    _dataUser = value;
    prefs.setString('ff_user', jsonEncode(value));
    notifyListeners();
  }

  List<dynamic> _roomList = [];
  List<dynamic> get roomList => _roomList;
  set roomList(List<dynamic> value) {
    _roomList = value;
    prefs.setString('ff_room_list', jsonEncode(value));
    notifyListeners();
  }

  List<dynamic> _roomStatus = [];
  List<dynamic> get roomStatus => _roomStatus;
  set roomStatus(List<dynamic> value) {
    _roomStatus = value;
    prefs.setString('ff_room_status', jsonEncode(value));
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

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
