import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/boiler_plate_widgets/common_app_bar.dart';
import '../../../../../core/widgets/boiler_plate_widgets/common_back_button.dart';
import '../../../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import '../../../bloc/compare_photos_bloc.dart';
import 'failure_result_widget.dart';
import 'image_analyzing_waiting_widget.dart';
import 'result_preview_widget.dart';

class ImageAnalyzingPageBody extends StatelessWidget {
  const ImageAnalyzingPageBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CommonPageBoilerPlate(
      horizontalPadding: 0,
      commonAppBar: BlocBuilder<ComparePhotosBloc, ComparePhotosState>(
        buildWhen: (previous, current) =>
            previous.comparePhotosState != current.comparePhotosState,
        builder: (context, state) {
          if (state.comparePhotosState!.isMatching ||
              state.comparePhotosState!.isNotMatching ||
              state.comparePhotosState!.isFailure) {
            return const CommonAppBar(
              leadingWidget: CommonBackButtonWidget(
                buttonText: "Back",
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      pageBody: Center(
        child: BlocBuilder<ComparePhotosBloc, ComparePhotosState>(
          buildWhen: (previous, current) =>
              previous.comparePhotosState != current.comparePhotosState,
          builder: (context, state) {
            switch (state.comparePhotosState) {
              case ComparePhotosStateStatus.initial:
              case ComparePhotosStateStatus.loading:
              case null:
                return const ImageAnalyzingWaitingWidget();
              case ComparePhotosStateStatus.matching:
                return  ResultPreviewWidget(
                  isMatching: true, percentage: state.comparePercentage ?? 0,
                );
              case ComparePhotosStateStatus.notMatching:
                return  ResultPreviewWidget(
                  isMatching: false, percentage: state.comparePercentage ?? 0,
                );
              case ComparePhotosStateStatus.failure:
                return const FailureResultWidget();
            }
          },
        ),
      ),
    );
  }
}
