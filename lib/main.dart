import 'package:flutter/material.dart';
import 'package:jc_housekeeping/routes/app_routes.dart';
import 'package:jc_housekeeping/app_state.dart';
import 'package:provider/provider.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.initializeState();

  runApp(
    ChangeNotifierProvider(
      create: (context) => appState,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> _initialRouteFuture;

  @override
  void initState() {
    super.initState();
    _initialRouteFuture = _checkStoredUser();
  }

  Future<String> _checkStoredUser() async {
    // Adjust based on actual implementation
    // For now, we return the login screen as the initial route
    return AppRoutes.login;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _initialRouteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return MaterialApp(
            title: 'JC House Keeping',
            theme: ThemeData(
              colorScheme: ColorScheme.light(),
              fontFamily: 'OpenSans',
            ),
            initialRoute: snapshot.data ?? AppRoutes.splashScreen,
            navigatorKey: navigatorKey,
            routes: AppRoutes.routes,
            debugShowCheckedModeBanner: false,
          );
        }
      },
    );
  }
}
