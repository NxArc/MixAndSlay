import 'package:fasionrecommender/data/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class themeButton extends StatelessWidget {
  const themeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.color_lens),
      onSelected: (value) {
        switch (value) {
          case 'light':
            // Switch to light mode
            themeModeNotifier.value = ThemeMode.light;
            break;
          case 'dark':
            // Switch to dark mode
            themeModeNotifier.value = ThemeMode.dark;
            break;
          case 'color':
            // Open color picker dialog
            _openColorPickerDialog(context);
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'light', child: Text('Light Mode')),
        PopupMenuItem(value: 'dark', child: Text('Dark Mode')),
        PopupMenuDivider(),
        PopupMenuItem(value: 'color', child: Text('Choose Theme Color')),
      ],
    );
  }

  // This function opens the color picker dialog
  void _openColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color currentColor = themeColorNotifier.value; // Get the current theme color

        return AlertDialog(
          title: const Text('Pick a Theme Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color color) {
                // Update the theme color when the user picks a color
                themeColorNotifier.value = color;
              },
              showLabel: false, // Optionally, remove the label
              pickerAreaHeightPercent: 0.8, // Adjust the picker area size
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // You can add additional actions here, if needed
              },
            ),
          ],
        );
      },
    );
  }
}
