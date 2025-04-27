import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';

class OutfitGrid extends StatelessWidget {
  const OutfitGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a list of image paths (updated to include four images)
    List<String> imagePaths = [
      'assets/images/onboard-bg.jpg',
      'assets/images/S2 EP7 4K (23).jpg', // Replace with your actual image path
      'assets/images/f72c10ba81298872a28a67723e1da6ce.jpg',
      'assets/images/Godrick.jpg',
      'assets/images/004588.png',
      'assets/images/Blaidd.jpg'
    ];

    return MasonryGridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        String imagePath = imagePaths[index];

        return Padding(
          padding: const EdgeInsets.all(8.0), // Reduced padding for tighter spacing
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return FutureBuilder<Size>(
                  future: _getImageSize(imagePath),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final imageSize = snapshot.data!;
                    final imageAspectRatio = imageSize.width / imageSize.height;
                    const minHeight = 150.0;
                    const maxHeight = 250.0; // Added maximum height to prevent very tall cells
                    final cellWidth = constraints.maxWidth;
                    final calculatedHeight = cellWidth / imageAspectRatio;
                    final cellHeight = calculatedHeight < minHeight
                        ? minHeight
                        : (calculatedHeight > maxHeight ? maxHeight : calculatedHeight);
                    return Container(
                      height: cellHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[300],
                      ),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover, // Changed to BoxFit.cover for better image scaling
                        width: cellWidth,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
  Future<Size> _getImageSize(String imagePath) async {
    final image = AssetImage(imagePath);
    final completer = Completer<Size>();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          completer.complete(Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          ));
        },
        onError: (exception, stackTrace) {
          completer.completeError(exception, stackTrace);
        },
      ),
    );
    return completer.future;
  }
}