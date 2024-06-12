import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/authentication/presentation/screens/login_view.dart';
import '../../features/dashboard/presentation/home_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String homeScreen = '/home_screen';
  static const String loginScreen = '/login_view';

  static Map<String, WidgetBuilder> get routes => {
        homeScreen: (context) => const HomeScreen(),
        loginScreen: (context) => const LoginView(),
      };
}
