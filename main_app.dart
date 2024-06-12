import 'dart:async';
import 'dart:developer';

import 'package:faceapp/core/constants/api_constants.dart';
import 'package:faceapp/core/widgets/common_snack_bar.dart';
import 'package:faceapp/features/myapi/bloc/myapi_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:faceapp/landing_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'config/routes/app_routes.dart';
import 'config/theme/data/app_theme.dart';
import 'core/services/shared_preferences_service.dart';
import 'features/authentication/bloc/auth_bloc/auth_provider.dart';
import 'features/category/bloc/category_provider.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/person/bloc/person_provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirstTime = true;

  Future<void> setupOnboard() async {
    bool isFirstTime = await SharedPreferencesService.getOnboard();
    if (!isFirstTime) {
      await SharedPreferencesService.setOnboard(true);
    }
    setState(() {
      _isFirstTime = isFirstTime;
    });
  }

  @override
  void initState() {
    super.initState();
    setupOnboard();
    setupInteractedMessage();
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic>? data = message.data;

    if (data.containsKey('forward_to')) {
      String action = data['forward_to'];
      if (action == 'dev_portal') {
        _gotoWebPortal();
      }
    }
    log("Message data: $data");
  }

  void _gotoWebPortal() async {
    const url = ApiConstants.sandboxBaseURL;
    try {
      await launch(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar.showErrorSnackBar(context, 'Error launching URL: $e'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            AuthProvider(),
            MyAPIProvider(),
            CategoryProvider(),
            PersonProvider(),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              CountryLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            home: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0), boldText:false),
              child: child!,
            ),
            routes: AppRoutes.routes,
            theme: AppThemeData.lightThemeData(),
            darkTheme: AppThemeData.darkThemeData(),
          ),
        );
      },
      child: _isFirstTime ? const LandingPage() : const OnboardingScreen(),
    );
  }
}
