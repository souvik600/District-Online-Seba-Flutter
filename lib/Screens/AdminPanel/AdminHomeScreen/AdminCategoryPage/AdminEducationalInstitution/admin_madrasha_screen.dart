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

class AdminMadrashaScreen extends StatefulWidget {
  @override
  _AdminMadrashaScreenState createState() => _AdminMadrashaScreenState();
}

class _AdminMadrashaScreenState extends State<AdminMadrashaScreen> {
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

  // Add madrasha
  Future<void> _addMadrasha() async {
    final data = {
      'name': _nameController.text.trim(),
      'location': _locationController.text.trim(),
      'contact': _contactController.text.trim(),
      'description': _descriptionController.text.trim(),
      'website': _websiteController.text.trim(),
      'email': _emailController.text.trim(),
      'establishedYear': _establishedYearController.text.trim(),
    };

    final docRef = await _firestore.collection('madrasha').add(data);
    if (_selectedImage != null) {
      final imageUrl = await _uploadImage(docRef.id);
      await docRef.update({'image': imageUrl});
    }

    Navigator.of(context).pop(); // Close bottom sheet
  }

  // Update madrasha
  Future<void> _updateMadrasha(String id) async {
    final data = {
      'name': _nameController.text.trim(),
      'location': _locationController.text.trim(),
      'contact': _contactController.text.trim(),
      'description': _descriptionController.text.trim(),
      'website': _websiteController.text.trim(),
      'email': _emailController.text.trim(),
      'establishedYear': _establishedYearController.text.trim(),
    };

    await _firestore.collection('madrasha').doc(id).update(data);

    if (_selectedImage != null) {
      final imageUrl = await _uploadImage(id);
      await _firestore.collection('madrasha').doc(id).update({'image': imageUrl});
    }

    Navigator.of(context).pop(); // Close bottom sheet
  }

  // Upload image
  Future<String> _uploadImage(String id) async {
    final ref = _storage.ref().child('madrasha_images/$id.jpg');
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

  // Delete madrasha
  Future<void> _deleteMadrasha(String id) async {
    await _firestore.collection('madrasha').doc(id).delete();
  }

  // Show form for adding/editing madrasha
  void _showMadrashaForm({String? id, Map<String, dynamic>? data}) {
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
                    data == null ? 'Add Madrasha' : 'Edit Madrasha',
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
                    decoration: AppInputDecoration('Madrasha Name'),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _locationController,
                    decoration: AppInputDecoration('Madrasha Location'),
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
                          _addMadrasha();
                        } else {
                          _updateMadrasha(id!);
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
                        data == null ? 'Add Madrasha' : 'Update Madrasha',
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => SchoolDetailsScreen(data: data)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Madrasha'),
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
                    hintText: 'Search Madrasha by Name ',
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
                      .collection('madrasha')
                      .where('name',
                      isGreaterThanOrEqualTo: _searchQuery)
                      .where('name',
                      isLessThanOrEqualTo: _searchQuery + '\uf8ff')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data();
                        return ListTile(
                          onTap: () => _openDetailsScreen(data),
                          leading: CircleAvatar(
                            backgroundImage: data['image'] != null
                                ? NetworkImage(data['image'])
                                : const AssetImage(
                                'assets/images/user.png') as ImageProvider,
                          ),
                          title: Text(data['name'] ?? ''),
                          subtitle: Text(data['location'] ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _showMadrashaForm(id: docs[index].id, data: data),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteMadrasha(docs[index].id),
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
        onPressed: () => _showMadrashaForm(),
        backgroundColor: AppColors.pColor.withOpacity(0.8),
        child: const Icon(Icons.add),
      ),
    );
  }
}
