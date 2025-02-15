import 'package:flutter/material.dart';
import 'package:kontena_hk/presentation/home_page/home_page.dart';
import 'package:kontena_hk/presentation/login_page/login_page.dart';
// import 'package:kontena_hk/presentation/splash_screen/splash_screen.dart';
import 'package:kontena_hk/presentation/lost_found_page/lost_found_page.dart';
import 'package:kontena_hk/presentation/profile_page.dart/profile_page.dart';
import 'package:kontena_hk/presentation/reservation_page/reservation_page.dart';
import 'package:kontena_hk/presentation/company/company_page.dart';

class AppRoutes {
  // static const String splashScreen = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String lostFound = '/lost-found';
  static const String profile = '/profile';
  static const String reservation = '/reservation';
  static const String company = '/company';

  static Map<String, WidgetBuilder> routes = {
    // splashScreen: (context) => SplashScreenPage(),
    home: (context) => HomePage(),
    login: (context) => LoginPage(),
    lostFound: (context) => LostFoundPage(),
    profile: (context) => ProfilePage(),
    reservation: (context) => ReservationPage(),
    company: (context) => CompanyPage(),
  };
}
