import 'package:flutter/material.dart';
import 'package:kontena_hk/routes/app_routes.dart';
import 'package:kontena_hk/app_state.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JC House Keeping',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(),
        fontFamily: 'OpenSans',
      ),
      initialRoute: AppRoutes.splashScreen,
      navigatorKey: navigatorKey,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
