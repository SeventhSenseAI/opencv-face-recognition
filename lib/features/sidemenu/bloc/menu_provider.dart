import 'package:faceapp/features/sidemenu/bloc/menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideMenuProvider extends BlocProvider<MenuBloc> {
  SideMenuProvider({
    super.key,
    required Widget child,
  }) : super(
          create: (context) => MenuBloc(),
          child: child,
        );
}