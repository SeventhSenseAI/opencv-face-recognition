import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../category/bloc/category_bloc.dart';
import '../../../category/bloc/category_event.dart';

class CollectionDetail extends StatelessWidget {
  final String name;
  final String collectionId;
  const CollectionDetail({
    super.key,
    required this.name,
    required this.collectionId,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
           textScaleFactor: 1.0,
          name,
          style: context.theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: ColorCodes.redColor,
            size: AppPaddings.p16.r,
          ),
          onPressed: () => {
            context.read<CategoryBloc>().add(
                  UpdateSelectedCollectionsPopup(
                    selectedCollections: [
                      ...context
                          .read<CategoryBloc>()
                          .state
                          .selectCollections
                          .where(
                            (collection) => collection.id != collectionId,
                          ),
                    ],
                  ),
                ),
          },
        ),
      ],
    );
  }
}
