import 'package:faceapp/features/authentication/bloc/register_bloc/register_bloc.dart';
import 'package:faceapp/features/authentication/presentation/screens/register_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterProvider extends BlocProvider<RegisterBloc> {
  RegisterProvider({
    super.key,
  }) : super(
          create: (context) => RegisterBloc(),
          child: const RegisterView(),
        );
}
