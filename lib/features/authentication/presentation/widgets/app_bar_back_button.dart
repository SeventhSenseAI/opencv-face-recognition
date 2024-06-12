import 'package:faceapp/core/utils/assets.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarBackButton extends StatelessWidget {
  final void Function()? backButtonOnTap;
  const AppBarBackButton({
    super.key,
    this.backButtonOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: backButtonOnTap ?? () => Navigator.pop(context),
      child: Row(
        children: [
          const SizedBox(
            width: 8,
          ),
          SizedBox(
            height: 22,
            width: 17,
            child: SvgPicture.asset(
              Assets.backArrowSvg,
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
             textScaleFactor: 1.0,
            'Back',
            style: context.theme.textTheme.titleMedium!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
