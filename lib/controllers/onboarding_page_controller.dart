import 'package:flutter/material.dart';

class OnboardingPageController {
  int counter = 0;

  void nextText({
    required BuildContext context,
    required int currentIndex,
    required int totalPages,
    required VoidCallback onFinish,
    required void Function(int newIndex, int newCounter) updateState,
  }) {
    if (counter < totalPages - 1) {
      counter++;
      updateState((currentIndex + 1) % totalPages, counter);
    } else {
      onFinish();
    }
  }

  void goBack({
    required BuildContext context,
    required int currentIndex,
    required int totalPages,
    required void Function(int newIndex, int newCounter) updateState,
  }) {
    if (counter > 0) {
      counter--;
      updateState((currentIndex - 1 + totalPages) % totalPages, counter);
    } else {
      Navigator.pop(context);
    }
  }
}
