



class OnboardingPageController {
  int counter = 0;

  /// Advances to the next page if possible
  /// Returns true if moved to next page, false if at the end
  bool moveToNextPage({
    required int totalPages,
    required void Function(int newIndex, int newCounter) updateState,
  }) {
    if (counter < totalPages - 1) {
      counter++;
      updateState(counter, counter); // Using counter as index since they align
      return true;
    }
    return false;
  }

  /// Moves back to the previous page if possible
  /// Returns true if moved back, false if at the start
  bool moveToPreviousPage({
    required int totalPages,
    required void Function(int newIndex, int newCounter) updateState,
  }) {
    if (counter > 0) {
      counter--;
      updateState(counter, counter);
      return true;
    }
    return false;
  }

  /// Gets the current page index
  int getCurrentIndex() => counter;

  /// Checks if we're on the last page
  bool isLastPage(int totalPages) => counter == totalPages - 1;

  /// Checks if we're on the first page
  bool isFirstPage() => counter == 0;
}