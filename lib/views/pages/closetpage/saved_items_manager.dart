import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fasionrecommender/services/storage/item_class.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SavedItemsManager {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save item to Firebase Storage and Firestore
  static Future<void> addItem(
    File imageFile,
    String type,
    String color,
    String brand,
    String size,
    String weatherType,
  ) async {
    try {
      // Upload the image to Firebase Storage
      String filePath =
          'closet_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask = _storage.ref(filePath).putFile(imageFile);

      // Wait for the upload to complete and get the URL
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Save the item metadata to Firestore
      await _firestore.collection('closet_items').add({
        'url': imageUrl,
        'type': type,
        'color': color,
        'brand': brand,
        'size': size,
        'weatherType': weatherType,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error uploading item: $e');
      throw Exception('Failed to upload item');
    }
  }

  static Future<List<ClosetImage>> getItems() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('saved_items').get();
      List<ClosetImage> items =
          snapshot.docs.map((doc) {
            return ClosetImage.fromMap(
              doc.data(),
            ); // Assuming you have a method to convert Firestore data to ClosetImage
          }).toList();
      return items;
    } catch (e) {
      print('Error fetching items: $e');
      return []; // Return an empty list on error
    }
  }

  // Check if item is already saved (based on image URL for simplicity)
  static Future<bool> contains(File imageFile) async {
    try {
      // Check Firestore for image URL match (this is a basic example)
      final QuerySnapshot result =
          await _firestore
              .collection('closet_items')
              .where('url', isEqualTo: imageFile.path)
              .get();
      return result.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Clear items (example)
  static Future<void> clearItems() async {
    try {
      // Delete all items from Firestore (optional)
      await _firestore.collection('closet_items').get().then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      print('Error clearing items: $e');
    }
  }
}
