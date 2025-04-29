import 'package:fasionrecommender/views/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../controllers/profile_setup_controller.dart'; // adjust import if needed
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileSetupPage extends StatefulWidget {
  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedGender;
  File? _profileImage;
  final ProfileSetupController _controller = ProfileSetupController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _createAccount() async {
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

    final success = await _controller.saveProfile(name, gender, imageUrl);


    if (!mounted) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: User not signed in.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success
        ? 'Profile created successfully!'
        : 'Failed to create profile, continuing...')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home()),
    );

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
                  onPressed: () => Navigator.pop(context),
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
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? Icon(Icons.camera_alt, size: 40)
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
                  prefixIcon: Icon(Icons.transgender),
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
                onPressed: _createAccount,
                child: Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
