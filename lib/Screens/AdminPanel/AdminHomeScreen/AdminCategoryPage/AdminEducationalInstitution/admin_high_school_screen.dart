import 'dart:io';
import 'package:district_online_service/AppColors/AppColors.dart';
import 'package:district_online_service/Screens/AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminEducationalInstitution/school_details_screen.dart';
import 'package:district_online_service/Styles/InputDecorationStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../Styles/BackGroundStyle.dart';

class AdminHighSchoolScreen extends StatefulWidget {
  @override
  _AdminHighSchoolScreenState createState() =>
      _AdminHighSchoolScreenState();
}

class _AdminHighSchoolScreenState extends State<AdminHighSchoolScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _establishedYearController =
  TextEditingController();

  XFile? _selectedImage;

  // Add school
  Future<void> _addSchool() async {
    final data = {
      'name': _nameController.text.trim(),
      'location': _locationController.text.trim(),
      'contact': _contactController.text.trim(),
      'description': _descriptionController.text.trim(),
      'website': _websiteController.text.trim(),
      'email': _emailController.text.trim(),
      'establishedYear': _establishedYearController.text.trim(),
    };

    final docRef = await _firestore.collection('highSchool').add(data);
    if (_selectedImage != null) {
      final imageUrl = await _uploadImage(docRef.id);
      await docRef.update({'image': imageUrl});
    }

    Navigator.of(context).pop(); // Close bottom sheet
  }

  // Update school
  Future<void> _updateSchool(String id) async {
    final data = {
      'name': _nameController.text.trim(),
      'location': _locationController.text.trim(),
      'contact': _contactController.text.trim(),
      'description': _descriptionController.text.trim(),
      'website': _websiteController.text.trim(),
      'email': _emailController.text.trim(),
      'establishedYear': _establishedYearController.text.trim(),
    };

    await _firestore.collection('highSchool').doc(id).update(data);

    if (_selectedImage != null) {
      final imageUrl = await _uploadImage(id);
      await _firestore
          .collection('highSchool')
          .doc(id)
          .update({'image': imageUrl});
    }

    Navigator.of(context).pop(); // Close bottom sheet
  }

  // Upload image
  Future<String> _uploadImage(String id) async {
    final ref = _storage.ref().child('high_school_images/$id.jpg');
    await ref.putFile(File(_selectedImage!.path));
    return await ref.getDownloadURL();
  }

  // Pick image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  // Delete school
  Future<void> _deleteSchool(String id) async {
    await _firestore.collection('highSchool').doc(id).delete();
  }

  // Show form for adding/editing school
  void _showSchoolForm({String? id, Map<String, dynamic>? data}) {
    if (data == null) {
      _nameController.clear();
      _locationController.clear();
      _contactController.clear();
      _descriptionController.clear();
      _websiteController.clear();
      _emailController.clear();
      _establishedYearController.clear();
      _selectedImage = null;
    } else {
      _nameController.text = data['name'];
      _locationController.text = data['location'];
      _contactController.text = data['contact'];
      _descriptionController.text = data['description'];
      _websiteController.text = data['website'];
      _emailController.text = data['email'];
      _establishedYearController.text = data['establishedYear'];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data == null ? 'Add School' : 'Edit School',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                        image: DecorationImage(
                          image: _selectedImage != null
                              ? FileImage(File(_selectedImage!.path))
                              : (data != null && data['image'] != null
                              ? NetworkImage(data['image'])
                              : const AssetImage(
                              'assets/images/user.png'))
                          as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: _selectedImage == null &&
                          (data == null || data['image'] == null)
                          ? const Icon(Icons.add_a_photo,
                          size: 50, color: Colors.grey)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _nameController,
                    decoration: AppInputDecoration('School Name'),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _locationController,
                    decoration: AppInputDecoration('School Location'),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _establishedYearController,
                    decoration: AppInputDecoration('Established Year'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _contactController,
                    decoration: AppInputDecoration('Contact Number'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _descriptionController,
                    decoration: AppInputDecoration('Description'),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _websiteController,
                    decoration: AppInputDecoration('Website'),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _emailController,
                    decoration: AppInputDecoration('Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (data == null) {
                          _addSchool();
                        } else {
                          _updateSchool(id!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pColor.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        data == null ? 'Add School' : 'Update School',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  void _openDetailsScreen(Map<String, dynamic> data) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SchoolDetailsScreen(data: data)));
  }

  // Search function
  // void _onSearchChanged(String query) {
  //   setState(() {
  //     _searchQuery = query;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('High School'),
      body: Stack(
        children: [
          ScreenBackground(context),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search School by Name ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _firestore
                      .collection('highSchool')
                      .where('name',
                      isGreaterThanOrEqualTo: _searchQuery)
                      .where('name',
                      isLessThanOrEqualTo: _searchQuery + '\uf8ff')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final schools = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: schools.length,
                      itemBuilder: (context, index) {
                        final data = schools[index].data();
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              // Background Image
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image:
                                        AssetImage('assets/icons/high-school.png'),
                                        fit: BoxFit.contain,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                              // Card with transparent background
                              Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.white.withOpacity(0.85), // Semi-transparent background
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.pColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: data['image'] != null
                                            ? Image.network(
                                          data['image'],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        )
                                            : const Icon(Icons.local_hospital, size: 50),
                                        title: Text(data['name'],style: TextStyle(fontSize: 18,color: AppColors.pColor,fontWeight: FontWeight.w500),),
                                        subtitle: Row(
                                          children: [
                                            const Icon(Icons.location_on_outlined,color: Colors.red,),
                                            Text(data['location']),
                                          ],
                                        ),
                                        onTap: () => _openDetailsScreen(data),
                                        trailing: const Icon(Icons.arrow_forward_ios_sharp),
                                      ),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () => _showSchoolForm(id: schools[index].id, data: data),
                                            child: const Text('Edit'),
                                          ),
                                          TextButton(
                                            onPressed: () => _deleteSchool(schools[index].id),
                                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSchoolForm(),
        backgroundColor: AppColors.pColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}


