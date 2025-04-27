import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fasionrecommender/services/storage/storage.dart';

class Testbuttons extends StatefulWidget {
  const Testbuttons({super.key});

  @override
  State<Testbuttons> createState() => _TestbuttonsState();
}

class _TestbuttonsState extends State<Testbuttons> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  
  // Controllers for the input fields
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _clothingTypeController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers to avoid memory leaks
    _categoryController.dispose();
    _colorController.dispose();
    _clothingTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<StorageService>(context);

    return Center(
      child: Column(
        children: [
          TextField(
            controller: _categoryController,
            decoration: InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _colorController,
            decoration: InputDecoration(
              labelText: 'Color',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _clothingTypeController,
            decoration: InputDecoration(
              labelText: 'Clothing Type',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              // Upload functionality
              if (_imageFile != null) {
                try {
                  await storageService.uploadClothingItem(
                    _imageFile!,
                    _categoryController.text, // Category from input
                    _colorController.text, // Color from input
                    _clothingTypeController.text,
                    "Null"
                  );
                  print('Upload successful');
                } catch (e) {
                  print('Upload failed: $e');
                }
              } else {
                print('No image selected');
              }
            },
            child: Text('Upload'),
          ),
          TextButton(
            onPressed: () async {
              // Retrieve functionality
              try {
                final items = await storageService.getClothingItemsByCategory(_categoryController.text);
                print('Retrieved items: $items');
              } catch (e) {
                print('Retrieve failed: $e');
              }
            },
            child: Text('Retrieve'),
          ),
          TextButton(
            onPressed: () async {
              // Delete functionality
              final itemId = 'item_id_here'; // Provide item ID to delete
              try {
                await storageService.deleteClothingItem(itemId);
                print('Item deleted successfully');
              } catch (e) {
                print('Delete failed: $e');
              }
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () async {
              // Pick an image from gallery
              try {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _imageFile = File(pickedFile.path);
                  });
                  print('Image picked: ${pickedFile.path}');
                } else {
                  print('No image selected');
                }
              } catch (e) {
                print('Image picking failed: $e');
              }
            },
            child: Text('Pick Image'),
          ),
        ],
      ),
    );
  }
}
