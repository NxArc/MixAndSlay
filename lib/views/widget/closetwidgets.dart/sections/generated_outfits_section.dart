import 'package:fasionrecommender/services/storage/outfits_service.dart';
import 'package:fasionrecommender/views/pages/closet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OutfitsSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const OutfitsSection({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final outfitService = Provider.of<OutfitService>(context, listen: false);

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withAlpha(50),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Outfits Collection',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child:
                  isExpanded
                      ? FutureBuilder<List<Map<String, dynamic>>>(
                        future: outfitService.retrieveOutfits(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Text(
                                'Error loading outfits.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            );
                          }

                          final outfits = snapshot.data;
                          if (outfits == null || outfits.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 12.0),
                              child: Text(
                                "You haven't saved any outfits yet.",
                                style: TextStyle(color: Colors.black54),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: outfits.length,
                              itemBuilder: (context, index) {
                                final item = outfits[index];
                                final outfitId = item['outfit_id'];

                                return GestureDetector(
                                  onTap: () {
                                    showOutfitDialog(context, outfitId);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['outfit_name'] ??
                                                    'Unnamed Outfit',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Occasion: ${item['occasion'] ?? '-'}',
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
                                              ),
                                              Text(
                                                'Weather: ${item['weatherFit'] ?? '-'}',
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            try {
                                              await outfitService.deleteOutfit(
                                                outfitId,
                                              );
                                              if (context.mounted) {
                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                        title: const Text(
                                                          'Success',
                                                        ),
                                                        content: const Text(
                                                          'Outfit deleted successfully.',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                            },
                                                            child: const Text(
                                                              'OK',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                );
                                              }
                                              onTap();
                                            } catch (e) {
                                              if (context.mounted) {
                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                        title: const Text(
                                                          'Error',
                                                        ),
                                                        content: Text(
                                                          'Failed to delete outfit: $e',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                            },
                                                            child: const Text(
                                                              'OK',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
