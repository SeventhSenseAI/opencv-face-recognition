import 'package:faceapp/core/services/baseurl_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/networking/api_provider.dart';
import '../../../authentication/bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/compare_photos_bloc.dart';
import '../../data/repository/image_repository.dart';
import '../widgets/image_upload/compare_photos_page_body_widget.dart';

class ComparePhotosPage extends StatelessWidget {
  const ComparePhotosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiKey = context.read<AuthBloc>().state.apiKey;
    final token = context.read<AuthBloc>().state.devToken;

    return BlocProvider<ComparePhotosBloc>(
      create: (context) => ComparePhotosBloc(
        imageRepository: ImageRepository(
          apiProvider: ApiProvider(baseURL: BaseURLService().baseURL),
        ),
      )..add(
          UpdateRepositories(
            apiKey: apiKey,
            token:token,
          ),
        ),
      child: const ComparePhotosPageBodyWidget(),
    );
  }
}
