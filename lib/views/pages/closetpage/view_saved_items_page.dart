import 'package:flutter/material.dart';
import 'package:fasionrecommender/services/storage/item_class.dart'; // Assuming ClosetImage class exists
import 'saved_items_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ViewSavedItemsPage extends StatelessWidget {
  const ViewSavedItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClosetImage>>(
      future: SavedItemsManager.getItems(), // Fetch the saved items
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error);
        }

        final savedItems = snapshot.data ?? [];

        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, true);
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildAppBar(context),
            body: savedItems.isEmpty
                ? _buildEmptyState()
                : _buildGridView(savedItems),
          ),
        );
      },
    );
  }

  // AppBar widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Saved Items',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Golos Text',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Loading state widget
  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  // Error state widget
  Widget _buildErrorState(dynamic error) {
    return Center(
      child: Text('Error: $error'),
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No saved items yet.',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
    );
  }

  // GridView widget
  Widget _buildGridView(List<ClosetImage> savedItems) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: savedItems.length,
      itemBuilder: (context, index) {
        final item = savedItems[index];
        return _buildGridItem(item);
      },
    );
  }

  // Grid item widget
  Widget _buildGridItem(ClosetImage item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: FutureBuilder<String>(
        future: _getImageUrl(item.url), // Fetch image URL
        builder: (context, urlSnapshot) {
          if (urlSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (urlSnapshot.hasError) {
            return Center(child: Text('Error loading image'));
          }

          final imageUrl = urlSnapshot.data;
          if (imageUrl == null) {
            return Center(child: Text('No image available'));
          }

          return Image.network(
            imageUrl,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  // Fetch the image URL from Firebase Storage using the file URL
  Future<String> _getImageUrl(String fileUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(fileUrl);
      return await ref.getDownloadURL(); // Return the download URL of the image
    } catch (e) {
      print("Error fetching image URL: $e");
      return ''; // Return an empty string in case of an error
    }
  }
}
