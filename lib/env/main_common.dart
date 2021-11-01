import 'package:customer/bloc_dependency.dart';
import 'package:customer/features/authentication/presentation/landing_screen.dart';
import 'package:customer/features/notifications/pages/notifications_screen.dart';
import 'package:customer/features/splash_screen/splash_screen.dart';
import 'package:customer/features/store_info/pages/store_info_screen.dart';
import 'package:customer/network/network_defaults.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/navigation/navigation_screen.dart';
import 'environment.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  Environment().load();
  String token = await NetworkDefaults.getToken();
  String refreshToken = await NetworkDefaults.getRefreshToken();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
  ));
  runApp(MyApp(isLogged: (token != null && refreshToken != null)));
}

class MyApp extends StatelessWidget {
  // Temporary
  final bool isLogged;

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
    return isLogged ? NavigationScreen() : SplashScreen();
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
