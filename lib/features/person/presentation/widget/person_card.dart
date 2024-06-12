import 'dart:convert';

import 'package:faceapp/features/category/bloc/category_bloc.dart';
import 'package:faceapp/features/category/bloc/category_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_paddings.dart';
import '../../../../core/constants/color_codes.dart';
import '../../../../core/utils/extensions.dart';
import '../../../search/data/model/user.dart';
import '../view_person_screen.dart';

class PersonCard extends StatefulWidget {
  final Person person;
  final bool isNeedsRedirectToMultipleFacesPage;
  final String baseMultipleFacesImage;
  final String compressBase64Image;

  const PersonCard({
    super.key,
    required this.person,
    required this.isNeedsRedirectToMultipleFacesPage,
    required this.baseMultipleFacesImage,
    required this.compressBase64Image,
  });

  @override
  State<PersonCard> createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 84.h,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: ColorCodes.greyColor,
              ),
            ),
          ),
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                radius: AppPaddings.p24.r,
                backgroundColor: ColorCodes.greyColor,
                backgroundImage: MemoryImage(
                  const Base64Decoder()
                      .convert(widget.person.thumbnails![0].thumbnail!),
                ),
              ),
              title: Text(
                 textScaleFactor: 1.0,
                widget.person.name!,
                style: context.theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
              contentPadding: const EdgeInsets.all(0),
              onTap: () {
                context.read<CategoryBloc>().add(
                      UpdateSelectedCollections(
                        selectedCollections: widget.person.collections ?? [],
                      ),
                    );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewPersonScreen(
                      isFaceLibrary: true,
                      baseMultipleFacesImage: widget.baseMultipleFacesImage,
                      compressBase64Image: widget.compressBase64Image,
                      isNeedsRedirectToMultipleFacesPage:
                          widget.isNeedsRedirectToMultipleFacesPage,
                      personID: widget.person.id!, isSavePerson: false,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
