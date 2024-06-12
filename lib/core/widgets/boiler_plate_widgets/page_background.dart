import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/assets.dart';

class PageBackground extends StatelessWidget {
  /// The [PageBackground] widget is used to add a
  /// visually appealing background to the page content.
  /// It creates a stack of positioned containers
  /// with different colors, providing a layered effect.
  /// The [body] parameter is used to specify the main
  /// content of the page.
  const PageBackground({
    super.key,
    required this.body,
  });
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        boldText: false, textScaler: const TextScaler.linear(1.0),
      ),
      child: Stack(
      children: [
        Positioned.fill(
          child: SvgPicture.asset(
            Assets.backgroundSvg,
            fit: BoxFit.fill,
          ),
        ),
        body,
      ],
      ),
    );
  }
}
