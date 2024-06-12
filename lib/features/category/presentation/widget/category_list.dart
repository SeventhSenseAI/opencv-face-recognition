import 'package:faceapp/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/category_item.dart';
import '../../bloc/category_bloc.dart';
import '../../bloc/category_state.dart';

class CategoryList extends StatelessWidget {
  final bool isFaceLib;
  final String? thumbnail;
  final String baseMultipleFacesImage;
  final String compressBase64Image;
  final bool isNeedsRedirectToMultipleFacesPage;
  final bool isSavePerson;

  const CategoryList({
    super.key,
    required this.isSavePerson,
    required this.isFaceLib,
    this.thumbnail,
    required this.baseMultipleFacesImage,
    required this.compressBase64Image,
    required this.isNeedsRedirectToMultipleFacesPage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: BlocBuilder<CategoryBloc, CategoryState>(
        buildWhen: (previous, current) =>
            previous.categoryList != current.categoryList, //||
            // previous.status != current.status,
        builder: (context, state) {
          return state.status == CategoryStatus.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : state.categoryList.isNotEmpty
                  ? Scrollbar(
                      radius: Radius.circular(5.r),
                      thickness: 3.spMax,
                      thumbVisibility: false,
                      trackVisibility: false,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: state.categoryList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CategoryItem(
                            baseMultipleFacesImage: baseMultipleFacesImage,
                            compressBase64Image: compressBase64Image,
                            isNeedsRedirectToMultipleFacesPage:
                                isNeedsRedirectToMultipleFacesPage,
                            collection: state.categoryList[index],
                            isFaceLib: isFaceLib,
                            thumbnail: thumbnail,
                            isAll: false, isSavePerson: isSavePerson,
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                         textScaleFactor: 1.0,
                        "No collection has been added yet",
                        style: context.theme.textTheme.bodyLarge,
                      ),
                    );
        },
      ),
    );
  }
}
