import 'dart:io';
import 'package:flutter/material.dart';
import 'saved_items_manager.dart';

class ViewSavedItemsPage extends StatefulWidget {
  const ViewSavedItemsPage({super.key});

  @override
  State<ViewSavedItemsPage> createState() => _ViewSavedItemsPageState();
}

class _ViewSavedItemsPageState extends State<ViewSavedItemsPage> {
  late List<File> savedItems;

  @override
  void initState() {
    super.initState();
    savedItems = List.from(SavedItemsManager.getItems());
  }

  void _removeItem(int index) {
    setState(() {
      SavedItemsManager.removeItem(savedItems[index]);
      savedItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
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
                      border: Border.all(
                        color: Colors.black,
                        width: 1.5,
                      ),
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
        ),
        body: savedItems.isEmpty
            ? const Center(
                child: Text(
                  'No saved items yet.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: savedItems.length,
                itemBuilder: (context, index) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          savedItems[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: -8,
                        right: -8,
                        child: GestureDetector(
                          onTap: () => _removeItem(index),
                          child: Container(
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.7),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0,2),
                                ),
                              ],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}