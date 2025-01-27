import 'dart:io';
import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Styles/ElevatedBottonStyle.dart';
import 'package:district_online_service/Styles/InputDecorationStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../../AppColors/AppColors.dart';
import '../../../../../Utilitys/utilitys.dart';

class UserElectricianServiceScreen extends StatefulWidget {
  @override
  _UserElectricianServiceScreenState createState() =>
      _UserElectricianServiceScreenState();
}

class _UserElectricianServiceScreenState extends State<UserElectricianServiceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  String _searchQuery = '';

  Future<void> _registerElectrician(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController specializationController = TextEditingController();
    TextEditingController contactController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    File? imageFile;

    Future<void> _pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: imageFile == null
                          ? const Icon(Icons.camera_alt,
                          size: 50, color: Colors.grey)
                          : Image.file(imageFile!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: AppInputDecoration('Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: specializationController,
                    decoration: AppInputDecoration('Specialization'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: contactController,
                    decoration: AppInputDecoration('Contact'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: locationController,
                    decoration: AppInputDecoration('Location'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: AppInputDecoration('Description'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButtonStyle(
                    onPressed: () async {
                      if (imageFile != null) {
                        final imageId = const Uuid().v4();
                        final storageRef = FirebaseStorage.instance
                            .ref()
                            .child('electrician_images/$imageId.jpg');

                        await storageRef.putFile(imageFile!);
                        final imageUrl = await storageRef.getDownloadURL();

                        await _firestore.collection('adminElectrician').add({
                          'name': nameController.text,
                          'specialization': specializationController.text,
                          'contact': contactController.text,
                          'location': locationController.text,
                          'description': descriptionController.text,
                          'imageUrl': imageUrl,
                          'isVisible': false, // Set to false initially for admin approval
                        });

                        // Show the success dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Registration Successful'),
                              content: const Text(
                                'Your registration is successful! Please wait for admin approval.',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                    Navigator.pop(context); // Close the bottom sheet
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please select an image.')),
                        );
                      }
                    },
                    text: 'Submit',
                  ),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('ইলেকট্রিশিয়ান'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _registerElectrician(context),
        backgroundColor: AppColors.pColor,
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          ScreenBackground(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('userElectrician')
                        .where('isVisible', isEqualTo: true) // Only show visible data
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final docs = snapshot.data!.docs;

                      if (docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No approved electrician services available.',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      // Filter by search query
                      final filteredDocs = docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final name = data['name']?.toLowerCase() ?? '';
                        return name.contains(_searchQuery);
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final data = filteredDocs[index].data()
                          as Map<String, dynamic>;
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage('assets/icons/electrician(1).png'),
                                        fit: BoxFit.contain,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: AppColors.wColor.withOpacity(.2),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5,
                                color: AppColors.wColor.withOpacity(.9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.pColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        // Image Section
                                        Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColors.pColor,
                                                    width: 2.0),
                                                borderRadius:
                                                BorderRadius.circular(8),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                                child: Image.network(
                                                  data['imageUrl'] ?? '',
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 10.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8.0),
                                                ),
                                                backgroundColor: Colors.teal,
                                              ),
                                              icon: const Icon(Icons.call,
                                                  size: 16,
                                                  color: Colors.white),
                                              label: const Text(
                                                "Call Now!",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                              onPressed: () => showCallDialog(
                                                  data['contact'] ?? 'N/A',
                                                  context),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 12.0),
                                        // Details Section
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              // Name and Specialization
                                              Row(
                                                children: [
                                                  const Icon(Icons.person,
                                                      size: 16,
                                                      color: Colors.black),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      data['name'] ?? 'No Name',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                data['specialization'] ?? 'N/A',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                              const Divider(),
                                              // Contact Information
                                              Row(
                                                children: [
                                                  const Icon(Icons.phone,
                                                      size: 16,
                                                      color: Colors.blue),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      data['contact'] ?? 'N/A',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.location_on,
                                                      size: 16,
                                                      color: Colors.green),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      data['location'] ?? 'N/A',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Icons.description,
                                                      size: 16,
                                                      color: Colors.amber),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      data['description'] ??
                                                          'N/A',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
