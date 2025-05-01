import 'package:fasionrecommender/views/widget/closetwidgets.dart/view_saved_items_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CollectionSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const CollectionSection({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final List<Map<String, String>> items = [
      {
        'imagePath': 'assets/images/onboard-bg.jpg',
        'title': 'Tops',
      },
      {
        'imagePath': 'assets/images/onboard-bg.jpg',
        'title': 'Headwear',
      },
      {
        'imagePath': 'assets/images/onboard-bg.jpg',
        'title': 'Bottoms',
      },
      {
        'imagePath': 'assets/images/onboard-bg.jpg',
        'title': 'Outerwear',
      },
      {
        'imagePath': 'assets/images/onboard-bg.jpg',
        'title': 'Footwear',
      },
      {
        'imagePath': 'assets/images/onboard-bg.jpg',
        'title': 'Accessories',
      },
    ];

    return GestureDetector(
      onTap: onTap,
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
                fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
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
                                  builder: (_) => ViewSavedItemsPage(category: title),
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
