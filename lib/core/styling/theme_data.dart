import 'package:flutter/material.dart';
import 'package:go_transitions/go_transitions.dart';

import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_styles.dart';

class AppThemes {
  static final lightTheme = ThemeData(
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: GoTransitions.slide.toTop.withFade,
          TargetPlatform.iOS: GoTransitions.slide.toTop.withFade,
          TargetPlatform.macOS: GoTransitions.slide.toTop.withFade,
        },
      ),
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.whiteColor,
      fontFamily: AppFonts.mainFontName,
      textTheme: TextTheme(
        titleLarge: AppStyles.primaryHeadLinesStyle,
        titleMedium: AppStyles.subtitlesStyles,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.primaryColor,
        disabledColor: AppColors.secondaryColor,
      ));
}
