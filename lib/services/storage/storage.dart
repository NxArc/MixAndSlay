import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageService with ChangeNotifier {
  final firebaseStorage = FirebaseStorage.instance;
  List<String> _imageUrls = [];
  bool _isLoading = false;
  bool _isUploading = false;

  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get isUploading => isUploading;


  //NOTE: IMAGES ARE STORED AS DOWNLOAD URLS

  //READ IMAGES
  Future<void> readImages() async {
    //start loading
    _isLoading = true;
    //get list under the directory
    final ListResult result = await firebaseStorage.ref('uploaded_images/').listAll();

    //get the download URLs for each image
    final urls = 
      await Future.wait(result.items.map((ref) => ref.getDownloadURL()));

    //Update URLs
    _imageUrls = urls;

    //loading finished
    _isLoading = false;

    //update UI
    notifyListeners();
  }


String extractPathFromUrl(String url){
      Uri uri = Uri.parse(url);

      //extracting path of the url
      String encodedPath = uri.pathSegments.last;

      return Uri.decodeComponent(encodedPath);
    }

  //DELETE IMAGES
  Future<void> deleteImage(String ImageUrl) async {
    try {
      //remove from local list
      _imageUrls.remove(ImageUrl);

      //get path and delete from firebase
      final String path = extractPathFromUrl(ImageUrl);
      await firebaseStorage.ref(path).delete();
    }catch(e){
      print("Error deleting image: $e");
    }

    notifyListeners();
  }


  //UPLOAD IMAGES
  Future<void> uploadImages() async {
    //start upload
    _isUploading = true;
    notifyListeners();

    //pick an image
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if(image == null) return;

    File file = File(image.path);

    try{
      //Define the path in storage
      String filePath = 'uploaded_images/${DateTime.now()}.png';

      //upload the file to firebase
      await firebaseStorage.ref(filePath).putFile(file);
      //fetch download url
      String downloadUrl = await firebaseStorage.ref(filePath).getDownloadURL();

      //update the image url list and UI
      _imageUrls.add(downloadUrl);
      notifyListeners();
    }catch (e){
      print('Error Uploading...$e');
    }

    finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}



