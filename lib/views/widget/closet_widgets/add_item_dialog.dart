import 'package:fasionrecommender/views/pages/closetpage/item_details_page.dart' show ItemDetailsPage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddItemDialog extends StatefulWidget {
  final Function(String) onOptionSelected;

  const AddItemDialog({super.key, required this.onOptionSelected});

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  String? _selectedOption;

  final ImagePicker _picker = ImagePicker();

  // Function to handle photo selection
  void _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Navigate to ItemDetailsPage with the selected image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetailsPage(imageFile: File(image.path)),
        ),
      );
    }
  }

  // Function to handle image selection from gallery
  void _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Navigate to ItemDetailsPage with the selected image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetailsPage(imageFile: File(image.path)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.41,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(26, 20, 26, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add an Item',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Option to take a photo
            _buildOption('photo', 'Take Photo', _pickImageFromCamera),

            const SizedBox(height: 5),

            // Option to upload from gallery
            _buildOption('gallery', 'Upload via Gallery', _pickImageFromGallery),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String value, String label, Function onTap) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = value;
        });
        onTap();
      },
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
              onTap();
            },
            activeColor: Colors.black,
          ),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
