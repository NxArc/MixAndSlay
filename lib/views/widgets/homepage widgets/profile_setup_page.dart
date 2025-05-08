import 'package:fasionrecommender/controllers/profile_controller.dart';
import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/data/responsive_utils.dart';
import 'package:fasionrecommender/views/pages/homepage.dart';
import 'package:fasionrecommender/views/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedGender;
  File? _profileImage;
  bool _isLoadingAvatar = false;

  final ProfileSetupController _controller = ProfileSetupController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _setupProfile() async {
    final name = _nameController.text.trim();
    final gender = _selectedGender;

    if (name.isEmpty || gender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    String? imageUrl;
    if (_profileImage != null) {
      imageUrl = await _controller.uploadProfileImage(_profileImage!);
    }

    final success = await _controller.updateProfile(name, gender, imageUrl);

    if (!mounted) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: User not signed in.')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Profile Saved!' : 'Profile Update Failed'),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home()),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final profile = await _controller.getProfile();
    if (profile != null) {
      setState(() {
        _selectedGender = profile['gender'];
        if (profile['username'] != null) {
          _nameController.text = profile['username'];
        }
      });

      if (profile['avatar_url'] != null) {
        try {
          setState(() => _isLoadingAvatar = true);
          final file = await _urlToFile(profile['avatar_url']);
          setState(() => _profileImage = file);
        } catch (e) {
          debugPrint('Failed to load avatar image: $e');
        } finally {
          setState(() => _isLoadingAvatar = false);
        }
      }
    }
  }

  Future<File> _urlToFile(String imageUrl) async {
    final response = await HttpClient().getUrl(Uri.parse(imageUrl));
    final imageData = await response.close();
    final bytes = await consolidateHttpClientResponseBytes(imageData);
    final file = File('${Directory.systemTemp.path}/profile_temp.jpg');
    return await file.writeAsBytes(bytes);
  }

  Icon _getGenderIcon(String? gender) {
    switch (gender) {
      case 'Male':
        return Icon(Icons.male);
      case 'Female':
        return Icon(Icons.female);
      case 'Other':
      default:
        return Icon(Icons.transgender);
    }
  }

  // Function to reset SharedPreferences
  Future<void> resetSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all stored data in SharedPreferences
    print('SharedPreferences reset!');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeColor = themeColorNotifier.value;

    final padding = ResponsiveUtils.paddingH(context);
    final vSpacing = ResponsiveUtils.paddingV(context);
    final titleFontSize = ResponsiveUtils.titleSize(context);
    final inputFontSize = ResponsiveUtils.inputFontSize(context);
    final buttonWidth = ResponsiveUtils.buttonWidth(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(height: vSpacing),
                Text(
                  'User Profile',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: vSpacing),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: buttonWidth * 0.25, // Adjust for responsiveness
                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                    backgroundImage:
                        _profileImage != null ? FileImage(_profileImage!) : null,
                    child:
                        _profileImage == null
                            ? (_isLoadingAvatar
                                ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    themeColor,
                                  ),
                                )
                                : Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ))
                            : null,
                  ),
                ),
                SizedBox(height: vSpacing * 0.8),
                Text(
                  'Choose',
                  style: TextStyle(
                    fontSize: inputFontSize * 0.9,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                SizedBox(height: vSpacing * 1.5),
                TextField(
                  controller: _nameController,
                  style: TextStyle(
                    fontSize: inputFontSize,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark ? Colors.grey[900] : Colors.grey[100],
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: themeColor.withOpacity(0.8),
                    ),
                  ),
                ),
                SizedBox(height: vSpacing),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark ? Colors.grey[900] : Colors.grey[100],
                    hintText: 'Select Gender',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: _getGenderIcon(_selectedGender),
                  ),
                  value: _selectedGender,
                  style: TextStyle(
                    fontSize: inputFontSize,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  dropdownColor: isDark ? Colors.grey[900] : Colors.white,
                  items: ['Male', 'Female', 'Other'].map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                SizedBox(height: vSpacing),
                SizedBox(
                  width: buttonWidth,
                  child: ValueListenableBuilder(
                    valueListenable: themeColorNotifier,
                    builder: (context, themeColor, _) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor.withOpacity(0.8),
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _setupProfile,
                        child: Text(
                          'Okay',
                          style: TextStyle(fontSize: inputFontSize),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: vSpacing),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? confirmed = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Confirm Reset'),
                content: Text(
                  'Are you sure you want to reset your profile data?',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes'),
                  ),
                ],
              );
            },
          );

          if (confirmed == true) {
            await resetSharedPreferences();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OnboardingPage(
                  onFinish: () {
                    // Your finish onboarding logic
                  },
                ),
              ),
            );
          }
        },
        child: const Icon(Icons.refresh),
        tooltip: 'Reset Profile Data',
      ),
    );
  }
}
