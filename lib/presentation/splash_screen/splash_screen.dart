import 'package:flutter/material.dart';
import 'package:kontena_hk/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  void _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString('phone') ?? '';
    String password = prefs.getString('password') ?? '';
    if (phone.isNotEmpty && password.isNotEmpty) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      _loadCredentials();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/image/logo_housekeeping.png',
          height: 200,
        ),
      ),
    );
  }
}
