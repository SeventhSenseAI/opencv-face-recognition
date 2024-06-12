import 'package:faceapp/features/authentication/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthProvider extends BlocProvider<AuthBloc> {
  AuthProvider({
    super.key,
  }) : super(
          create: (context) => AuthBloc(),
        );
}
