import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'saved_items_manager.dart';
import 'view_saved_items_page.dart';

class ItemDetailsPage extends StatefulWidget {
  final File imageFile;

  const ItemDetailsPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  final ScrollController _imageScrollController = ScrollController();

  // Dropdown state variables
  String _selectedType = 'Shirt';
  String _selectedColor = 'Black';
  String _selectedBrand = 'UNIQLO';
  String _selectedSize = 'M';
  String _selectedWeather = 'Casual';

  // Dropdown options
  final List<String> _types = ['Shirt', 'Pants', 'Shoes', 'Dress'];
  final List<String> _colors = ['Black', 'White', 'Blue', 'Red', 'Beige'];
  final List<String> _brands = ['UNIQLO', 'ZARA', 'H&M', 'Nike'];
  final List<String> _sizes = ['S', 'M', 'L', 'XL'];
  final List<String> _weatherTypes = ['Casual', 'Cold', 'Rainy', 'Summer'];

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
    super.dispose();
  }

  // ========================
  // Take Another Photo
  // ========================
  void _takeAnotherPhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetailsPage(imageFile: File(image.path)),
        ),
      );
    }
  }

  // ========================
  // Bottom Sheet on Save
  // ========================
  void _showSavedOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(26, 20, 26, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/saved_icon.png',
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 12),
              const Text(
                'Saved in Closet!',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF383737),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Create an outfit',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _takeAnotherPhoto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF918E8E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Take another photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewSavedItemsPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'View Saved Items',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      color: Color(0xFF383737),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ========================
  // Build UI
  // ========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Item Details',
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
                  SavedItemsManager.clearItems();
                  Navigator.pop(context);
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
                    Icons.arrow_back_ios,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: FileImage(widget.imageFile),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Item Information',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              DropdownButton<String>(
                value: _selectedType,
                isExpanded: true,
                items: _types.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newType) {
                  setState(() {
                    _selectedType = newType!;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedColor,
                isExpanded: true,
                items: _colors.map((String color) {
                  return DropdownMenuItem<String>(
                    value: color,
                    child: Text(color),
                  );
                }).toList(),
                onChanged: (String? newColor) {
                  setState(() {
                    _selectedColor = newColor!;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedBrand,
                isExpanded: true,
                items: _brands.map((String brand) {
                  return DropdownMenuItem<String>(
                    value: brand,
                    child: Text(brand),
                  );
                }).toList(),
                onChanged: (String? newBrand) {
                  setState(() {
                    _selectedBrand = newBrand!;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedSize,
                isExpanded: true,
                items: _sizes.map((String size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size),
                  );
                }).toList(),
                onChanged: (String? newSize) {
                  setState(() {
                    _selectedSize = newSize!;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedWeather,
                isExpanded: true,
                items: _weatherTypes.map((String weather) {
                  return DropdownMenuItem<String>(
                    value: weather,
                    child: Text(weather),
                  );
                }).toList(),
                onChanged: (String? newWeather) {
                  setState(() {
                    _selectedWeather = newWeather!;
                  });
                },
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Add item to Firebase
                    await SavedItemsManager.addItem(
                      widget.imageFile,
                      _selectedType,
                      _selectedColor,
                      _selectedBrand,
                      _selectedSize,
                      _selectedWeather,
                    );
                    _showSavedOptionsBottomSheet();
                  },
                  child: const Text('Save Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
