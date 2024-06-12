import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/utils/assets.dart';
import '../../../bloc/compare_photos_bloc.dart';
import '../../pages/image_analyzing_page.dart';

class BottomScanButtonWidget extends StatelessWidget {
  const BottomScanButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComparePhotosBloc, ComparePhotosState>(
      buildWhen: (previous, current) =>
          previous.imageUploadState != current.imageUploadState,
      builder: (context, state) {
        if (state.imageUploadState!.isSuccess) {
          return Positioned.fill(
            bottom: AppPaddings.p16.h,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: SizedBox(
                  height: 100.r,
                  width: 100.r,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SvgPicture.asset(
                          Assets.searchSvg,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.black.withOpacity(
                              0.5,
                            ),
                            highlightColor: Colors.transparent,
                            onTap: () {
                              context
                                  .read<ComparePhotosBloc>()
                                  .add(CompareImages());

                              final bloc = context.read<ComparePhotosBloc>();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageAnalyzingPage(
                                    comparePhotosBloc: bloc,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
