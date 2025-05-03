import 'package:fasionrecommender/data/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:fasionrecommender/views/widgets/closetwidgets.dart/sections/collection_section.dart';
import 'package:fasionrecommender/views/widgets/closetwidgets.dart/popups/outfit_display.dart';
import 'package:fasionrecommender/views/widgets/closetwidgets.dart/popups/add_item_bottom_sheet.dart';
import 'package:fasionrecommender/views/widgets/closetwidgets.dart/sections/generated_outfits_section.dart';

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
        backgroundColor: Theme.of(context).colorScheme.onSurface
        
        ,
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
                icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Closet',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: titleFontSize,
                color: Theme.of(context).colorScheme.onSurface,
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
                ElevatedButton.icon(
                  onPressed: () {
                    showAddItemDialog(context);
                  },
                  icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
                  label: Text(
                    'New Item',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
          );
        },
      ),
    );
  }
}
