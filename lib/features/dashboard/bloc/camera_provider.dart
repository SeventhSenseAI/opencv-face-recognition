import 'package:flutter_bloc/flutter_bloc.dart';

import 'camera_bloc.dart';


class CameraProvider extends BlocProvider<CameraBloc> {
  CameraProvider({super.key,}) : super(
          create: (context) => CameraBloc(),);
}

