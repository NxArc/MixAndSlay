import 'package:fasionrecommender/views/widgets/object%20widgets/view_saved_items_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollectionSection extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const CollectionSection({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<CollectionSection> createState() => _CollectionSectionState();
}

class _CollectionSectionState extends State<CollectionSection> {
  String? gender;

  @override
  void initState() {
    super.initState();
    fetchGender();
  }

  Future<void> fetchGender() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final response =
        await Supabase.instance.client
            .from('profiles')
            .select('gender')
            .eq('id', userId)
            .single();

    // ignore: unnecessary_null_comparison
    if (mounted && response != null && response['gender'] != null) {
      setState(() {
        gender =
            response['gender'].toString().toLowerCase(); // 'male' or 'female'
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final List<Map<String, String>> maleDisplay = [
      {'imagePath': 'assets/images/stock_images/maleDisplay/male_tops.jpg', 'title': 'Tops'},
      {'imagePath': 'assets/images/stock_images/maleDisplay/male_headwear.jpg', 'title': 'Headwear'},
      {'imagePath': 'assets/images/stock_images/maleDisplay/male_bottom.jpg', 'title': 'Bottoms'},
      {'imagePath': 'assets/images/stock_images/maleDisplay/male_outerwear.jpg', 'title': 'Outerwear'},
      {'imagePath': 'assets/images/stock_images/maleDisplay/male_footwear.jpg', 'title': 'Footwear'},
      {'imagePath': 'assets/images/stock_images/maleDisplay/male_accessories.jpg', 'title': 'Accessories'},
    ];

    final List<Map<String, String>> femaleDisplay = [
      {'imagePath': 'assets/images/stock_images/femaleDisplay/female_tops.jpg', 'title': 'Tops'},
      {'imagePath': 'assets/images/stock_images/femaleDisplay/female_headwear.jpg', 'title': 'Headwear'},
      {'imagePath': 'assets/images/stock_images/femaleDisplay/female_bottom.jpg', 'title': 'Bottoms'},
      {'imagePath': 'assets/images/stock_images/femaleDisplay/female_outerwear.jpg', 'title': 'Outerwear'},
      {'imagePath': 'assets/images/stock_images/femaleDisplay/female_footwear.jpg', 'title': 'Footwear'},
      {'imagePath': 'assets/images/stock_images/femaleDisplay/female_accessories.jpg', 'title': 'Accessories'},
    ];
    final List<Map<String, String>> othersDisplay = [
      {'imagePath': 'assets/female/tops.jpg', 'title': 'Tops'},
      {'imagePath': 'assets/female/headwear.jpg', 'title': 'Headwear'},
      {'imagePath': 'assets/female/bottoms.jpg', 'title': 'Bottoms'},
      {'imagePath': 'assets/female/outerwear.jpg', 'title': 'Outerwear'},
      {'imagePath': 'assets/female/footwear.jpg', 'title': 'Footwear'},
      {'imagePath': 'assets/female/accessories.jpg', 'title': 'Accessories'},
    ];
    final items =
        gender == 'female'
            ? femaleDisplay
            : gender == 'male'
            ? maleDisplay
            : othersDisplay; // Empty while loading or unknown

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withAlpha(50),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Collection',
              style: textTheme.titleMedium?.copyWith(
                fontWeight:
                    widget.isExpanded ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child:
                  widget.isExpanded && items.isNotEmpty
                      ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: MasonryGridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final imagePath = item['imagePath']!;
                            final title = item['title']!;

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            ViewSavedItemsPage(category: title),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      imagePath,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    title,
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
