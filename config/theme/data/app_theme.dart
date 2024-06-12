import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/font_family.dart';

abstract class AppThemeData {
  AppThemeData._();

  /// [darkThemeData] define Dark Theme Configuration
  static ThemeData darkThemeData() {
    return ThemeData.dark().copyWith(
      /// [Common Text Style Usage Guide:]
      ///
      /// This guide demonstrates how to use common text styles in your Flutter project for consistent typography.
      ///
      /// 1. **Check for Similar Typography in ThemeData:**
      ///    Before defining text styles, check if there are similar styles available in the
      ///    ThemeData corresponding with figma typography properties.
      ///    For example, to use a 'titleSmall' style, you can directly use:
      ///
      ///   Sample extracted typography from Figma:
      ///   - font-family: SF Pro;
      ///   - font-size: 14px;
      ///   - font-weight: 700;
      ///
      ///    ```dart
      ///    style: context.theme.textTheme.titleSmall,
      ///    ```
      ///
      /// 2. **Customization Using `copyWith`:**
      ///    If Figma or other design tools specify additional properties, use the `copyWith` method to customize styles:
      ///
      ///   Sample extracted typography from Figma:
      ///   - font-family: SF Pro;
      ///   - font-size: 13px;
      ///   - font-weight: 510;
      ///   - line-height: 21px;
      ///   - text-align: center;
      ///   - color: #FFFFFF;
      ///
      ///    ```dart
      ///    style: context.theme.textTheme.titleSmall!.copyWith(
      ///      color: Colors.white,
      ///      fontSize: 13.sp,
      ///      fontWeight: FontWeight.w500,
      ///      // Additional properties as per design requirements
      ///    ),
      ///    textAlign: TextAlign.center,
      ///    ```
      ///
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 64.sp,
          fontWeight: FontWeight.w400,
          fontFamily: FontsFamily.sfPro,
          color: Colors.white,
        ),
        headlineLarge: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.w500,
          fontFamily: FontsFamily.sfPro,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          fontFamily: FontsFamily.sfPro,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          fontFamily: FontsFamily.sfPro,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontFamily: FontsFamily.sfPro,
          color: Colors.white,
        ),
        titleSmall: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          fontFamily: FontsFamily.sfPro,
          color: Colors.white,
        ),
        labelSmall: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          fontFamily: FontsFamily.sfPro,
          color: Colors.white,
        ),
      ),
    );
  }

  /// [lightThemeData] define light Theme Configuration
  static ThemeData lightThemeData() {
    return ThemeData.light().copyWith(
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 64.sp,
          fontWeight: FontWeight.w400,
          fontFamily: FontsFamily.sfPro,
          color: Colors.white,
        ),
        headlineLarge: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.w500,
          fontFamily: FontsFamily.sfPro,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          fontFamily: FontsFamily.sfPro,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          fontFamily: FontsFamily.sfPro,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleSmall: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          fontFamily: FontsFamily.sfPro,
          color: Colors.white,
        ),
        labelSmall: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          fontFamily: FontsFamily.sfPro,
          color: Colors.white,
        ),
      ),
    );
  }
}
