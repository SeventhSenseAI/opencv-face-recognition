import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/search_bloc.dart';
import '../../data/repository/search_repository.dart';
import '../widgets/search_page_body_widget.dart';

class ImageIdentifyPage extends StatelessWidget {
  const ImageIdentifyPage({
    super.key,
    required this.base64Image,
    required this.compressBase64Image,
    required this.isLivenessCheck,
  });

  final String base64Image;
  final String compressBase64Image;
  final bool isLivenessCheck;

  @override
  Widget build(BuildContext context) {
    final apiKey = context.read<AuthBloc>().state.apiKey;
    final token = context.read<AuthBloc>().state.devToken;

    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
        searchDataRepository: SearchDataRepository(),
      )..add(
          UpdateRepositories(
            apiKey: apiKey,
            token: token,
            base64Image: base64Image,
            isLivenessCheck: isLivenessCheck,
            compressBase64Image: compressBase64Image,
          ),
        ),
      child: SearchPageBodyWidget(
        base64Image: base64Image,
        // imageXFile: imageXFile!,
        compressBase64Image: compressBase64Image,
      ),
    );
  }
}
