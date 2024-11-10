import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../AppColors/AppColors.dart';
import '../../../Authentication/user_login_screen.dart';
import '../../../Styles/BackGroundStyle.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String name = '';
  String location = '';
  String email = '';
  String profileImageUrl = '';
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Fetch the user's profile from Firestore
  Future<void> _loadUserProfile() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            name = userDoc['full_name'] ?? 'No Name';
            location = userDoc['address'] ?? 'No Location';
            email = user!.email ?? 'No Email';
            profileImageUrl = userDoc['avatar_url'] ?? '';
          });
        }
      } catch (e) {
        print("Error loading user profile: $e");
      }
    }
  }

  // Logout function
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserLogInScreen()),
    );
  }

  // Function to handle image selection from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadProfileImage();
    }
  }

  // Upload the selected image to Firebase Storage and update Firestore
  Future<void> _uploadProfileImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_avatars/${user!.uid}.jpg');
      await storageRef.putFile(_imageFile!);
      String imageUrl = await storageRef.getDownloadURL();

      // Update the user's profile in Firestore
      await FirebaseFirestore.instance.collection('users')
          .doc(user!.uid)
          .update({
        'avatar_url': imageUrl,
      });

      setState(() {
        profileImageUrl = imageUrl;
      });
    } catch (e) {
      print("Error uploading profile image: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "প্রোফাইল",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              fontFamily: 'kalpurush',
              color: colorWhite,
            ),
          ),
          backgroundColor: AppColors.pColor,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Stack(
            children: [
              ScreenBackground(context),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // Profile Picture with Edit Icon
                    Stack(
                      children: [
                        // Profile Picture
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: profileImageUrl.isNotEmpty
                              ? NetworkImage(profileImageUrl)
                              : const AssetImage(
                              'assets/images/user.png') as ImageProvider,
                        ),
                        // Edit Icon
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _pickImage,
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 25,
                              child: Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Name
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Email
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Location
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Logout Button
                    ElevatedButton(
                      onPressed: _logout,
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.wColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 8),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Tab Bar
                    const SizedBox(height: 30),
                    const TabBar(
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.black,
                      indicatorColor: Colors.black,
                      tabs: [
                        Tab(child: Text("Blood Donner"),),
                        Tab(icon: Icon(Icons.video_collection)),
                        Tab(icon: Icon(Icons.video_collection)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
