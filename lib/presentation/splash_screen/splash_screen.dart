import 'package:flutter/material.dart';
import 'package:kontena_hk/presentation/home_page/home_page.dart';
import 'package:kontena_hk/presentation/login_page/login_page.dart';
import 'package:kontena_hk/presentation/lost_found_page/lost_found_add_page.dart';
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
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
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
          'assets/image/logo-kontena.png', // Make sure to replace with the actual path to your logo
          height: 80, // Set the desired height
        ),
      ),
    );
  }
}
