import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final bool isEnabled;

  const ImageButton({
    super.key,
    required this.imagePath,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
