import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/items_details_page.dart';

class AddItemController {
  final ImagePicker _picker = ImagePicker();

  Future<void> handleContinue(BuildContext context, String? selectedOption) async {
    if (selectedOption == null) return;

    await Future.delayed(const Duration(milliseconds: 300));
    File? imageFile;

    if (selectedOption == 'photo') {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );
      if (photo != null) imageFile = File(photo.path);
    } else if (selectedOption == 'gallery') {
      final XFile? galleryImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (galleryImage != null) imageFile = File(galleryImage.path);
    }

    if (imageFile != null) {
      _showPreviewDialog(context, imageFile);
    }
  }

  void _showPreviewDialog(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    imageFile,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF383737),
                        textStyle: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize:15,
                        )
                      )
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemDetailsPage(imageFile: imageFile),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:const Color(0xFF383737),
                        foregroundColor:Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
