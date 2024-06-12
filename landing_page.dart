import 'dart:developer';

import 'package:faceapp/core/services/shared_preferences_service.dart';
import 'package:faceapp/features/myapi/bloc/myapi_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'features/authentication/bloc/auth_bloc/auth_bloc.dart';
import 'features/authentication/presentation/screens/login_view.dart';
import 'features/category/bloc/category_bloc.dart';
import 'features/dashboard/presentation/home_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/person/bloc/person_bloc.dart';

import 'features/category/bloc/category_event.dart' as category;
import 'features/person/bloc/person_event.dart' as person;

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // listenWhen: (previous, current) => previous.apiKey != current.apiKey,
      listener: (context, state) {
        if (state.authStatus == AuthStatus.authenticated) {
          context.read<MyapiBloc>().add(
                InitializeSearch(),
              );

          context.read<CategoryBloc>().add(
                category.UpdateRepositories(
                  apiKey: context.read<AuthBloc>().state.apiKey,
                  token: context.read<AuthBloc>().state.devToken,
                ),
              );

          context.read<PersonBloc>().add(
                person.UpdateRepositories(
                  apiKey: context.read<AuthBloc>().state.apiKey,
                  token: context.read<AuthBloc>().state.devToken,
                ),
              );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (pre, current) => pre.authStatus != current.authStatus,
        builder: (context, state) {
          log("MyApp -> Auth Status ${state.authStatus}");
            if (state.authStatus == AuthStatus.authenticated) {
              FlutterNativeSplash.remove();
              return const HomeScreen();
            } else if (state.authStatus == AuthStatus.unauthenticated) {
              FlutterNativeSplash.remove();
              return const LoginView();
            }
          return Container();
        },
      ),
    );
  }
}
