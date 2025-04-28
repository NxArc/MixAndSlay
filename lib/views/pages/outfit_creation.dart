import 'package:flutter/material.dart';
import 'package:fasionrecommender/data/responsive_utils.dart';

class OutfitCreationPage extends StatefulWidget {
  const OutfitCreationPage({super.key});

  @override
  State<OutfitCreationPage> createState() => _OutfitCreationPageState();
}

class _OutfitCreationPageState extends State<OutfitCreationPage> {
  final TextEditingController _outfitNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.paddingH(context),
          vertical: ResponsiveUtils.paddingV(context),
        ),
        child: Column(
          children: [
            TextField(
              controller: _outfitNameController,
              style: TextStyle(
                fontSize: ResponsiveUtils.inputFontSize(context),
              ),
              decoration: InputDecoration(
                labelText: 'Outfit Name',
                labelStyle: TextStyle(
                  fontSize: ResponsiveUtils.inputFontSize(context),
                ),
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: ResponsiveUtils.paddingV(context)),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Function for Headwear selection
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.paddingV(context) / 2,
                      ),
                      padding: EdgeInsets.all(ResponsiveUtils.paddingV(context)),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey.shade200,
                            child: Icon(Icons.add_photo_alternate_outlined),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Select Headwear',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.inputFontSize(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Function for Top selection
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.paddingV(context) / 2,
                      ),
                      padding: EdgeInsets.all(ResponsiveUtils.paddingV(context)),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey.shade200,
                            child: Icon(Icons.add_photo_alternate_outlined),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Select Top',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.inputFontSize(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Function for Bottom selection
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.paddingV(context) / 2,
                      ),
                      padding: EdgeInsets.all(ResponsiveUtils.paddingV(context)),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey.shade200,
                            child: Icon(Icons.add_photo_alternate_outlined),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Select Bottom',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.inputFontSize(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Function for Footwear selection
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.paddingV(context) / 2,
                      ),
                      padding: EdgeInsets.all(ResponsiveUtils.paddingV(context)),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey.shade200,
                            child: Icon(Icons.add_photo_alternate_outlined),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Select Footwear',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.inputFontSize(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Function for Accessories selection
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.paddingV(context) / 2,
                      ),
                      padding: EdgeInsets.all(ResponsiveUtils.paddingV(context)),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey.shade200,
                            child: Icon(Icons.add_photo_alternate_outlined),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Select Accessories',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.inputFontSize(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: ResponsiveUtils.paddingV(context),
                bottom: ResponsiveUtils.buttonPadding(context),
              ),
              child: SizedBox(
                width: ResponsiveUtils.buttonWidth(context),
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Function for creating the outfit
                  },
                  child: Text(
                    'Create Outfit',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.inputFontSize(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
