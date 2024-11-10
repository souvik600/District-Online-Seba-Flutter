import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> loadProfileImage() async {
  User? user = FirebaseAuth.instance.currentUser;
  String profileImageUrl = '';

  if (user != null) {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      profileImageUrl = userDoc['avatar_url'] ?? ''; // Get the avatar URL
    }
  }
  return profileImageUrl;
}