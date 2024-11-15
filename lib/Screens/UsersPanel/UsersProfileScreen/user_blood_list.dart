import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../../AppColors/AppColors.dart';
import '../../../Styles/BackGroundStyle.dart';

class UserBloodList extends StatefulWidget {
  @override
  _UserBloodListState createState() => _UserBloodListState();
}

class _UserBloodListState extends State<UserBloodList> {
  User? user = FirebaseAuth.instance.currentUser;
  final _picker = ImagePicker();
  XFile? _imageFile;
  String? _name, _contact, _location, _bloodGroup;
  int? _age;
  bool _availability = true; // Default to available
  bool _isLoading = false;

  List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void initState() {
    super.initState();
    _loadUserBlood();
  }

  // Fetch the user's profile from Firestore
  Future<void> _loadUserBlood() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('blood_donors')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _name = userDoc['name'] ?? 'No Name';
            _contact = userDoc['contact'] ?? 'No contact';
            _location = userDoc['address'] ?? 'No Location';
            _bloodGroup = userDoc['bloodGroup'] ?? 'Not Provided';
            _availability = userDoc['availability'] ?? true;
            _age = userDoc['age'] ?? 0;
          });
        }
      } catch (e) {
        print("Error loading user profile: $e");
      }
    }
  }

  // Function to delete a donor
  Future<void> _deleteDonor(String donorId, int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('blood_donors')
          .doc(donorId)
          .delete();
      // Optionally, update the UI or show a confirmation message
    } catch (e) {
      print("Error deleting donor: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,  // Three tabs to match the TabBar
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            ScreenBackground(context),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Card(
                  elevation: 8,
                  color: AppColors.wColor.withOpacity(.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.pColor, width: 1.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                            ),
                            child: _imageFile != null
                                ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.pColor,
                                      width: 2.0),
                                  borderRadius:
                                  BorderRadius.circular(5),
                                ),
                                child: Image.file(
                                  File(_imageFile!.path),
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                                : Image.asset(
                              'assets/images/user.png',
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Flexible(
                                      child: Text(
                                        _name ?? 'No Name',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.bColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Colors.blueAccent,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Flexible(
                                      child: Text(
                                        _location ?? 'No Location',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.bColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.cake,
                                      size: 18,
                                      color: Colors.purpleAccent,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Flexible(
                                      child: Text(
                                        'Age: ${_age ?? 0}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.bColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 18,
                                      color: Colors.blueAccent,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Flexible(
                                      child: Text(
                                        _contact ?? 'No contact',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.bColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 12,
                                      color: _availability
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(width: 6.0),
                                    Text(
                                      _availability
                                          ? 'Available'
                                          : 'Not Available',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: _availability
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.red.shade500,
                                child: Text(
                                  _bloodGroup ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'kalpurush',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _deleteDonor(user!.uid, 0); // Pass index if required
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  _deleteDonor(user!.uid, 0); // Pass index if required
                                },
                              ),
                              // IconButton(
                              //   icon: const Icon(
                              //     Icons.edit,
                              //     color: Colors.blue,
                              //   ),
                              //   // onPressed: () {
                              //   //   showModalBottomSheet(
                              //   //     context: context,
                              //   //     isScrollControlled: true,
                              //   //     shape: const RoundedRectangleBorder(
                              //   //       borderRadius: BorderRadius.vertical(
                              //   //           top: Radius.circular(25)),
                              //   //     ),
                              //   //     builder: (BuildContext context) {
                              //   //       return EditDonorFormScreen(donor: ,
                              //   //       );
                              //   //     },
                              //   //   );
                              //   // },
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
