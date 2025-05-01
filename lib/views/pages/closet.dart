import 'package:fasionrecommender/data/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/outfit_creation.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/sections/collection_section.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/popups/outfit_display.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/popups/add_item_bottom_sheet.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/sections/generated_outfits_section.dart';

class VirtualClosetPage extends StatefulWidget {
  const VirtualClosetPage({super.key});

  @override
  State<VirtualClosetPage> createState() => _VirtualClosetPageState();
}

Future<void> showOutfitDialog(BuildContext context, String outfitId) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                child: OutfitDisplayWidget(outfitID: outfitId),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _VirtualClosetPageState extends State<VirtualClosetPage> {
  int? expandedIndex; // 0 = Collection, 1 = Generated Outfits

  void toggleExpand(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveUtils.paddingH(context);
    final verticalPadding = ResponsiveUtils.paddingV(context);
    final titleFontSize = ResponsiveUtils.titleSize(context);
    final buttonPadding = ResponsiveUtils.buttonPadding(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Closet',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: titleFontSize,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CollectionSection(
                  isExpanded: expandedIndex == 0,
                  onTap: () => toggleExpand(0),
                ),
                SizedBox(height: verticalPadding * 0.75),
                OutfitsSection(
                  isExpanded: expandedIndex == 1,
                  onTap: () => toggleExpand(1),
                ),
                SizedBox(height: verticalPadding * 1.2),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        showAddItemDialog(context);
                      },
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: const Text(
                        'New Item',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF918E8E),
                        padding: EdgeInsets.symmetric(
                          horizontal: buttonPadding,
                          vertical: verticalPadding,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                    SizedBox(width: horizontalPadding * 0.5),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OutfitCreationPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: const Text(
                        'Make Outfit',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF918E8E),
                        padding: EdgeInsets.symmetric(
                          horizontal: buttonPadding,
                          vertical: verticalPadding,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
