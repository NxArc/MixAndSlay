import 'package:flutter/material.dart';

ValueNotifier<int> selectPageNotifier = ValueNotifier(0);
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(false);
final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
final themeColorNotifier = ValueNotifier<Color>(Colors.teal);
