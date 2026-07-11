import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static TextStyle pixelTitle({double size = 18, Color color = Colors.black}) {
    return GoogleFonts.pressStart2p(
      fontSize: size,
      color: color,
      height: 1.4,
    );
  }

  static TextStyle pixelBody({double size = 10, Color color = Colors.black}) {
    return GoogleFonts.pressStart2p(
      fontSize: size,
      color: color,
      height: 1.5,
    );
  }

  static TextStyle pixelSubtitle({double size = 8, Color color = AppColors.oliveGreen}) {
    return GoogleFonts.pressStart2p(
      fontSize: size,
      color: color,
      height: 1.6,
    );
  }

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lavender,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.oliveGreen,
        primary: AppColors.oliveGreen,
        secondary: AppColors.softPink,
        surface: AppColors.cardWhite,
      ),
      textTheme: TextTheme(
        bodyMedium: pixelBody(),
        titleLarge: pixelTitle(),
      ),
    );
  }
}
