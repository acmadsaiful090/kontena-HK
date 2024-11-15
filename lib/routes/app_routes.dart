import 'package:flutter/material.dart';
import 'package:jc_housekeeping/presentation/home_page/home_page.dart';
import 'package:jc_housekeeping/presentation/login_page/login_page.dart';
import 'package:jc_housekeeping/presentation/splash_screen/splash_screen.dart';
import 'package:jc_housekeeping/presentation/lost_found_page/lost_found_page.dart';
import 'package:jc_housekeeping/presentation/profile_page.dart/profile_page.dart';
import 'package:jc_housekeeping/presentation/reservation_page/reservation_page.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String lostFound = '/lost-found';
  static const String profile = '/profile';
  static const String reservation = '/reservation';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashScreenPage(),
    home: (context) => HomePage(),
    login: (context) => LoginPage(),
    lostFound: (context) => LostFoundPage(),
    profile: (context) => ProfilePage(),
    reservation: (context) => ReservationPage(),
  };
}
