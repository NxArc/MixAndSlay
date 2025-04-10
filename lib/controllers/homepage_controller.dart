import 'package:fasionrecommender/views/pages/authenticate/aunthenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';

final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }