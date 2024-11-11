import 'package:flutter/material.dart';
import 'package:kontena_hk/routes/app_routes.dart';
import 'package:kontena_hk/app_state.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => appState),
      ],
      child: MyApp(),
    ),
  );
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
      initialRoute: AppRoutes.splashScreen, 
      routes: AppRoutes.routes, 
      debugShowCheckedModeBanner: false,
    );
  }
}
