import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double paddingH(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width * 0.05; // 5% of screen width
  }

  static double paddingV(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.height * 0.02; // 2% of screen height
  }

  static double titleSize(BuildContext context, {bool isTablet = false}) {
    final size = MediaQuery.of(context).size;
    return isTablet ? size.width * 0.06 : size.width * 0.08;
  }

  static double subtitleSize(BuildContext context, {bool isTablet = false}) {
    final size = MediaQuery.of(context).size;
    return isTablet ? size.width * 0.03 : size.width * 0.035;
  }

  static double buttonPadding(BuildContext context, {bool isTablet = false}) {
    return isTablet ? 32.0 : 16.0;
  }
   static double inputFontSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    return isTablet ? size.width * 0.035 : size.width * 0.04;
  }
  static double buttonWidth(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width * 0.7; // 70% of screen width
  }
}
