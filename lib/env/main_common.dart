import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staffapp/bloc_dependency.dart';
import 'package:staffapp/features/authentication/presentation/pages/authentication_screen.dart';
import 'package:staffapp/features/navigation/navigation_shell.dart';
import 'package:staffapp/network/network_defaults.dart';

import 'environment.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  Environment().load();
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  String token = await NetworkDefaults.getToken();
  String refreshToken = await NetworkDefaults.getRefreshToken();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.grey[100],
  ));
  runApp(MyApp(isLogged: (token != null && refreshToken != null)));
}

class MyApp extends StatelessWidget {
  // Temporary
  bool isLogged = false;

  MyApp({this.isLogged});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocDependency
          .setRemoteBlocs(), // change to setTestBlocs if we want to use mock data
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: _setThemeData(),
        home: _startingScreen(),
      ),
    );
  }

  /// Function that dictates the starting screen.
  /// In this case will check if the user is logged in and request authentication
  /// if necessary.
  Widget _startingScreen() {
    return isLogged ? NavigationShell() : AuthenticationScreen();
  }

  _setThemeData() {
    return ThemeData(
        primaryColor: Colors.black, buttonTheme: _setButtonTheme());
  }

  _setButtonTheme() {
    return ButtonThemeData(
        buttonColor: Colors.black,
        minWidth: double.infinity,
        height: 48,
        shape: RoundedRectangleBorder(),
        textTheme: ButtonTextTheme.primary);
  }
}
