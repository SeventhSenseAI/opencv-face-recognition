import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/compare_photos_bloc.dart';
import '../widgets/image_analyzing/image_analyzing_page_body.dart';

class ImageAnalyzingPage extends StatelessWidget {
  const ImageAnalyzingPage({
    super.key,
    required this.comparePhotosBloc,
  });

  final ComparePhotosBloc comparePhotosBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ComparePhotosBloc>.value(
      value: comparePhotosBloc,
      child: const ImageAnalyzingPageBody(),
    );
  }
}
