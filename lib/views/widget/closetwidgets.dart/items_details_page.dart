import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/data/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fasionrecommender/services/storage/storage.dart';
import 'package:provider/provider.dart'; // Import your notifiers.dart file

class ItemDetailsPage extends StatefulWidget {
  final File imageFile;
  const ItemDetailsPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  final ScrollController _imageScrollController = ScrollController();
  final TextEditingController _nameController = TextEditingController();

  String? selectedCategory;
  String? selectedColor;
  String? selectedClothingType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_imageScrollController.hasClients) {
        final maxScroll = _imageScrollController.position.maxScrollExtent;
        _imageScrollController.jumpTo(maxScroll / 2);
      }
    });
  }

  @override
  void dispose() {
    _imageScrollController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    final String name = _nameController.text;
    final String category = selectedCategory ?? '';
    final String color = selectedColor ?? '';
    final String clothingType = selectedClothingType ?? '';

    final storageService = Provider.of<StorageService>(context, listen: false);

    await storageService.uploadClothingItem(
      widget.imageFile,
      color,
      clothingType,
      name,
      category,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBar(
              backgroundColor: isDarkMode ? Colors.black : Colors.white,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'Add Item To Closet',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontFamily: 'Golos Text',
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveUtils.subtitleSize(
                    context,
                    isTablet: isTablet,
                  ),
                ),
              ),
              leading: Padding(
                padding: EdgeInsets.only(left: ResponsiveUtils.paddingH(context)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDarkMode ? Colors.white : Colors.black,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.close,
                        color: isDarkMode ? Colors.white : Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.paddingH(context),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: ResponsiveUtils.paddingV(context)),

                      Container(
                        height: size.height * 0.30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.15),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.file(widget.imageFile, fit: BoxFit.cover),
                      ),
                      SizedBox(height: ResponsiveUtils.paddingV(context)),

                      Column(
                        children: [
                          Text(
                            'Information',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.subtitleSize(
                                context,
                                isTablet: isTablet,
                              ),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),

                          SizedBox(height: ResponsiveUtils.paddingV(context) * 0.5),

                          TextField(
                            controller: _nameController,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.inputFontSize(context),
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                fontSize: ResponsiveUtils.inputFontSize(context),
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                            ),
                          ),

                          SizedBox(height: ResponsiveUtils.paddingV(context)),

                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.inputFontSize(context),
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Category',
                              labelStyle: TextStyle(
                                fontSize: ResponsiveUtils.inputFontSize(context),
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                            ),
                            items:
                                ['Formal', 'Party', 'Swimming', 'Ewan'].map((size) {
                                  return DropdownMenuItem<String>(
                                    value: size,
                                    child: Text(
                                      size,
                                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                          ),

                          SizedBox(height: ResponsiveUtils.paddingV(context)),

                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.inputFontSize(context),
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Color',
                              labelStyle: TextStyle(
                                fontSize: ResponsiveUtils.inputFontSize(context),
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                            ),
                            items:
                                ['Red', 'Yellow', 'Green', 'Blue'].map((color) {
                                  return DropdownMenuItem<String>(
                                    value: color,
                                    child: Text(
                                      color,
                                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedColor = value;
                              });
                            },
                          ),

                          SizedBox(height: ResponsiveUtils.paddingV(context)),

                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.inputFontSize(context),
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Clothing Type',
                              labelStyle: TextStyle(
                                fontSize: ResponsiveUtils.inputFontSize(context),
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                            ),
                            items:
                                ['T-shirt', 'Dress', 'Jeans', 'Shorts'].map((color) {
                                  return DropdownMenuItem<String>(
                                    value: color,
                                    child: Text(
                                      color,
                                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedClothingType = value;
                              });
                            },
                          ),

                          SizedBox(height: ResponsiveUtils.paddingV(context)),
                        ],
                      ),

                      SizedBox(height: ResponsiveUtils.paddingV(context)),

                      SizedBox(
                        width: ResponsiveUtils.buttonWidth(context),
                        child: ElevatedButton(
                          onPressed: () {
                            try {
                              _saveItem();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Item saved successfully!')),
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to save item. Please try again.',
                                  ),
                                ),
                              );
                              print("Error: $e");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF918E8E),
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveUtils.paddingV(context),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.inputFontSize(context),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: ResponsiveUtils.paddingV(context)),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
