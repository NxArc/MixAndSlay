import 'package:flutter/material.dart';
import 'package:fasionrecommender/controllers/add_item_controller.dart';

final AddItemController _controller = AddItemController();
String? _selectedOption;

void showAddItemDialog(BuildContext context) {
  final parentContext = context;
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
                          color: Colors.black,
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
                              Navigator.pop(context); // Close bottom sheet
                              await _controller.handleContinue(parentContext, _selectedOption);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color(0xFF383737),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        disabledBackgroundColor: const Color(0xFF918E8E),
                      ),
                      child: const Text(
                        'Continue',
                        style: 
                        TextStyle(
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
