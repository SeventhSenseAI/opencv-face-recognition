// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faceapp/core/constants/nationalities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/features/person/bloc/person_bloc.dart';
import 'package:faceapp/features/person/bloc/person_event.dart';
import 'package:faceapp/features/person/bloc/person_state.dart';

class ComboBoxInput extends StatelessWidget {
  final Function(String)? onSelectCountry;

  const ComboBoxInput({
    super.key,
    required this.onSelectCountry,
  });

  @override
  Widget build(BuildContext context) {
    final PersonBloc personBloc = BlocProvider.of<PersonBloc>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
           textScaleFactor: 1.0,
          AppLocalizations.of(context)!.nationality,
          style: context.theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPaddings.p16.w,
          ),
          decoration: BoxDecoration(
            color: ColorCodes.greyColor.withOpacity(0.4),
            borderRadius: BorderRadius.all(
              Radius.circular(5.r),
            ),
            border: Border.all(
              color: ColorCodes.greyColor,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorCodes.blackColor.withOpacity(0.01),
                spreadRadius: 0,
                blurRadius: 100,
                offset: const Offset(
                  0,
                  0,
                ),
              ),
            ],
          ),
          margin: EdgeInsets.only(
            top: AppPaddings.p4.h,
            bottom: AppPaddings.p16.h,
          ),
          height: 56.h,
          child: BlocBuilder<PersonBloc, PersonState>(
            buildWhen: (previous, current) =>
                current.nationality != previous.nationality,
            builder: (context, state) {
              final nationality =
                  state.nationality == "" ? null : state.nationality;
              return DropdownButton<String>(
                dropdownColor: ColorCodes.greyColor,
                isExpanded: true,
                value: nationality,
                underline: Container(
                  height: 0,
                ),
                style: context.theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w300,
                ),
                onChanged: (newValue) {
                  onSelectCountry!(newValue!);
                  personBloc.add(
                    SetNationalityEvent(
                      nationality: newValue,
                    ),
                  );
                },
                items: nationalities.map((String nationality) {
                  return DropdownMenuItem<String>(
                    value: nationality,
                    child: Text( textScaleFactor: 1.0,nationality),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
