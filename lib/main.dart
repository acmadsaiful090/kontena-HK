import 'package:flutter/material.dart';
import 'package:kontena_hk/presentation/home_page/home_page.dart';
import 'package:kontena_hk/presentation/login_page/login_page.dart';
import 'package:kontena_hk/presentation/splash_screen/splash_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kontena HK',
      theme: ThemeData(
        colorScheme: ColorScheme.light(),
        
        fontFamily: 'OpenSans',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreenPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
