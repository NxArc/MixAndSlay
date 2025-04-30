import 'package:fasionrecommender/controllers/homepage_controller.dart';
import 'package:fasionrecommender/views/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../controllers/profile_setup_controller.dart';

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
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _SetupProfile() async {
    final name = _nameController.text.trim();
    final gender = _selectedGender;

    if (name.isEmpty || gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: User not signed in.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Profile Saved!' : 'Profile Update Failed')),
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
          setState(() {
            _isLoadingAvatar = true;
          });

          final file = await _urlToFile(profile['avatar_url']);
          setState(() {
            _profileImage = file;
          });
        } catch (e) {
          debugPrint('Failed to load avatar image: $e');
        } finally {
          setState(() {
            _isLoadingAvatar = false;
          });
        }
      }
    }
  }

  Future<File> _urlToFile(String imageUrl) async {
    final response = await HttpClient().getUrl(Uri.parse(imageUrl));
    final imageData = await response.close();
    final bytes = await consolidateHttpClientResponseBytes(imageData);
    final tempDir = Directory.systemTemp;
    final file = File('${tempDir.path}/profile_temp.jpg');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    signOut();
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Almost There!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? (_isLoadingAvatar
                          ? CircularProgressIndicator()
                          : Icon(Icons.camera_alt, size: 40))
                      : null,
                ),
              ),
              SizedBox(height: 10),
              Text('Choose'),
              SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Select Gender',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  prefixIcon: _getGenderIcon(_selectedGender),
                ),
                value: _selectedGender,
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.black,
                ),
                onPressed: _SetupProfile,
                child: Text('Okay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
