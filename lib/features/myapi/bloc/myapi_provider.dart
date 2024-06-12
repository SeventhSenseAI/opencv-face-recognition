// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:faceapp/features/myapi/bloc/myapi_bloc.dart';

class MyAPIProvider extends BlocProvider<MyapiBloc> {
  MyAPIProvider({
    super.key,
   super.child,
  }) : super(
          create: (context) => MyapiBloc(),
        );
}