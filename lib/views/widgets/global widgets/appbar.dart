import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/views/widgets/global%20widgets/theme_button.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) {
        final platformBrightness = MediaQuery.of(context).platformBrightness;
        final isDark = themeMode == ThemeMode.dark ||
            (themeMode == ThemeMode.system &&
                platformBrightness == Brightness.dark);

        return AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Image.asset(
            isDark
                ? 'assets/images/logoDark.png'
                : 'assets/images/logoLight.png',
            height: 55,
          ),
          actions: [
            themeButton(),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
