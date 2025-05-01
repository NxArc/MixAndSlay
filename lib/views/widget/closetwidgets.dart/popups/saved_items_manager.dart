// saved_items_manager.dart
import 'dart:io';

class SavedItemsManager {
  static final List<File> _savedItems = [];

  static void addItem(File item) {
    _savedItems.add(item);
  }

  static List<File> getItems() {
    return _savedItems; // prevents external modification
  }

  static void clearItems() {
    _savedItems.clear(); // optional: for future use
  }

  static bool contains (File imageFile){
    return _savedItems.any((item)=> item.path == imageFile.path);
  }

  static void removeItem(File item) {
    _savedItems.removeWhere((savedItem) => savedItem.path == item.path);
  }
}