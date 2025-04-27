import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/items_details_page.dart';

final ImagePicker _picker = ImagePicker();
String? _selectedOption;

void showAddItemDialog(BuildContext context) {
  final parentContext = context; // Save parent context
  _selectedOption = null;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.41,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 20, 26, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        _selectedOption = _selectedOption == 'photo' ? null : 'photo';
                      });
                    },
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'photo',
                          groupValue: _selectedOption,
                          onChanged: (value) {
                            setModalState(() {
                              _selectedOption = _selectedOption == value ? null : value;
                            });
                          },
                          activeColor: Colors.black,
                        ),
                        const Text(
                          'Take Photo',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        _selectedOption = _selectedOption == 'gallery' ? null : 'gallery';
                      });
                    },
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'gallery',
                          groupValue: _selectedOption,
                          onChanged: (value) {
                            setModalState(() {
                              _selectedOption = _selectedOption == value ? null : value;
                            });
                          },
                          activeColor: Colors.black,
                        ),
                        const Text(
                          'Upload via Gallery',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedOption != null
                          ? () async {
                              Navigator.pop(context);
                              await Future.delayed(const Duration(milliseconds: 300));

                              if (_selectedOption == 'photo') {
                                final XFile? photo = await _picker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 100,
                                );
                                if (photo != null) {
                                  _showPreviewDialog(parentContext, File(photo.path));
                                }
                              } else if (_selectedOption == 'gallery') {
                                final XFile? galleryImage = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 85,
                                );
                                if (galleryImage != null) {
                                  _showPreviewDialog(parentContext, File(galleryImage.path));
                                }
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF383737),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        disabledBackgroundColor: const Color(0xFF918E8E),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF383737),
                      textStyle: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    child: const Text('Cancel'),
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
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
