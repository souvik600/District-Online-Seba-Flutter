import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../AppColors/AppColors.dart';
import '../../../Styles/BackGroundStyle.dart';
import '../../../Widgets/edit_doner_buttom_sheet.dart';

class UserBloodList extends StatefulWidget {
  @override
  _UserBloodListState createState() => _UserBloodListState();
}

class _UserBloodListState extends State<UserBloodList> {
  User? user = FirebaseAuth.instance.currentUser;
  String? _name, _contact, _location, _bloodGroup, _imageUrl;
  int? _age;
  String? _availability = 'Available'; // Default value
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserBlood();
  }
  // Fetch the user's profile from Firestore
  Future<void> _loadUserBlood() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('blood_donors')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _name = userDoc['name'] ?? 'No Name';
            _contact = userDoc['contact'] ?? 'No Contact';
            _location = userDoc['location'] ?? 'No Location';
            _bloodGroup = userDoc['bloodGroup'] ?? 'N/A';
            _availability = userDoc['availability'] ?? 'Not Available';
            _age = userDoc['age'] ?? 0;
            _imageUrl = userDoc['image_url'] ?? null;
          });
        } else {
          print("No data found for user: ${user!.uid}");
        }
      }
    } catch (e) {
      print("Error loading user profile: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Delete donor with confirmation dialog
  void _confirmDeleteDonor(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Donor'),
        content: const Text('Are you sure you want to delete this donor?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('blood_donors')
                  .doc(id)
                  .delete();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Donor deleted successfully")),
              );
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ScreenBackground(context),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          if (!_isLoading)
            RefreshIndicator(
              onRefresh: _loadUserBlood, // Trigger refresh
              child: SingleChildScrollView(
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
                          color: AppColors.pColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          // Image Section
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0),
                              ),
                              child: _imageUrl != null
                                  ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.pColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Image.network(
                                    _imageUrl!,
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

                          // Information Section
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _infoRow(Icons.person, _name ?? 'No Name'),
                                  const SizedBox(height: 8.0),
                                  _infoRow(Icons.location_on, _location ?? "No"),
                                  const SizedBox(height: 8.0),
                                  _infoRow(Icons.cake, 'Age: ${_age ?? 0}'),
                                  const SizedBox(height: 8.0),
                                  _infoRow(Icons.phone, _contact ?? 'No Contact'),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 12,
                                        color: _availability == 'Available'
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      const SizedBox(width: 6.0),
                                      Text(
                                        _availability ?? 'Not Available',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: _availability == 'Available'
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

                          // Actions Section
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
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    // Show bottom sheet for editing the donor details
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                                      ),
                                      builder: (BuildContext context) {
                                        return EditDonorBottomSheet(
                                          name: _name ?? '',
                                          contact: _contact ?? '',
                                          location: _location ?? '',
                                          bloodGroup: _bloodGroup ?? '',
                                          age: _age ?? 0,
                                          availability: _availability ?? 'Not Available',
                                          imageUrl: _imageUrl ?? '',
                                          onSubmit: (name, contact, location, bloodGroup, age, availability, imageUrl) {
                                            // Update Firestore with the new data
                                            FirebaseFirestore.instance
                                                .collection('blood_donors')
                                                .doc(user!.uid)
                                                .update({
                                              'name': name,
                                              'contact': contact,
                                              'location': location,
                                              'bloodGroup': bloodGroup,
                                              'age': age,
                                              'availability': availability,
                                              'image_url': imageUrl,
                                            }).then((_) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Donor details updated successfully')),
                                              );
                                              // Reload the user data to reflect the changes
                                              _loadUserBlood();
                                            }).catchError((e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Failed to update donor: $e')),
                                              );
                                            });
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),

                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _confirmDeleteDonor(user!.uid);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper widget to display information row
  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.blueAccent,
        ),
        const SizedBox(width: 6.0),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
