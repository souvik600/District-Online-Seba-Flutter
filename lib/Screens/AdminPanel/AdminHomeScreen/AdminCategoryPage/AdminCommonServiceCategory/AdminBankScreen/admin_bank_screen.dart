import 'dart:io';
import 'package:district_online_service/AppColors/AppColors.dart';
import 'package:district_online_service/Styles/InputDecorationStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../Styles/BackGroundStyle.dart';

class AdminBankScreen extends StatefulWidget {
  @override
  _AdminBankScreenState createState() => _AdminBankScreenState();
}

class _AdminBankScreenState extends State<AdminBankScreen> {
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

  XFile? _selectedImage;

  // Add bank
  Future<void> _addBank() async {
    final data = {
      'name': _nameController.text.trim(),
      'location': _locationController.text.trim(),
      'contact': _contactController.text.trim(),
      'description': _descriptionController.text.trim(),
      'website': _websiteController.text.trim(),
      'email': _emailController.text.trim(),
    };

    final docRef = await _firestore.collection('banks').add(data);
    if (_selectedImage != null) {
      final imageUrl = await _uploadImage(docRef.id);
      await docRef.update({'image': imageUrl});
    }

    Navigator.of(context).pop(); // Close bottom sheet
  }

  // Update bank
  Future<void> _updateBank(String id) async {
    final data = {
      'name': _nameController.text.trim(),
      'location': _locationController.text.trim(),
      'contact': _contactController.text.trim(),
      'description': _descriptionController.text.trim(),
      'website': _websiteController.text.trim(),
      'email': _emailController.text.trim(),
    };

    // Update the existing bank with new data
    await _firestore.collection('banks').doc(id).update(data);

    // If image was changed, upload it and update the image field
    if (_selectedImage != null) {
      final imageUrl = await _uploadImage(id);
      await _firestore.collection('banks').doc(id).update({'image': imageUrl});
    }

    Navigator.of(context).pop(); // Close bottom sheet
  }

  // Upload image
  Future<String> _uploadImage(String id) async {
    final ref = _storage.ref().child('bank_images/$id.jpg');
    await ref.putFile(File(_selectedImage!.path));
    return await ref.getDownloadURL();
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> _deleteBank(String id) async {
    await _firestore.collection('banks').doc(id).delete();
  }

  // Show form for adding or editing bank
  void _showBankForm({String? id, Map<String, dynamic>? data}) {
    // Reset form fields if no data
    if (data == null) {
      _nameController.clear();
      _locationController.clear();
      _contactController.clear();
      _descriptionController.clear();
      _websiteController.clear();
      _emailController.clear();
      _selectedImage = null;
    } else {
      // Pre-fill form with existing data
      _nameController.text = data['name'];
      _locationController.text = data['location'];
      _contactController.text = data['contact'];
      _descriptionController.text = data['description'];
      _websiteController.text = data['website'];
      _emailController.text = data['email'];
      if (data['image'] != null) {
        _selectedImage = null; // Reset image if updating (optional)
      }
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
                    data == null ? 'Add Bank' : 'Edit Bank',
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
                      decoration: AppInputDecoration('Bank Name')),
                  const SizedBox(height: 8.0),
                  TextField(
                      controller: _locationController,
                      decoration: AppInputDecoration('Bank Location')),
                  const SizedBox(height: 8.0),
                  TextField(
                      controller: _contactController,
                      decoration: AppInputDecoration('Contact Number'),
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 8.0),
                  TextField(
                      controller: _descriptionController,
                      decoration: AppInputDecoration("Description")),
                  const SizedBox(height: 8.0),
                  TextField(
                      controller: _websiteController,
                      decoration: AppInputDecoration('Website')),
                  const SizedBox(height: 8.0),
                  TextField(
                      controller: _emailController,
                      decoration: AppInputDecoration('Email'),
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (data == null) {
                          _addBank(); // Add bank if data is null
                        } else {
                          _updateBank(
                              id!); // Update bank if data is provided
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pColor.withOpacity(.8),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: Text(
                          data == null ? 'Add Bank' : 'Update Bank',
                          style: const TextStyle(color: Colors.white, fontSize: 18)),
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
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BankDetailsScreen(data: data)));
  }

  // Search function
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Bank'),
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
                    hintText: 'Search Bank by Name or Location',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _firestore
                      .collection('banks')
                      .where('name', isGreaterThanOrEqualTo: _searchQuery)
                      .where('name',
                      isLessThanOrEqualTo: _searchQuery + '\uf8ff')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final banks = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: banks.length,
                      itemBuilder: (context, index) {
                        final data = banks[index].data();
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/icons/bank.png'),
                                        fit: BoxFit.contain,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.white.withOpacity(0.85),
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
                                            : const Icon(Icons.account_balance,
                                            size: 50),
                                        title: Text(
                                          data['name'],
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: AppColors.pColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.red,
                                            ),
                                            Text(data['location']),
                                          ],
                                        ),
                                        onTap: () =>
                                            _openDetailsScreen(data),
                                        trailing: const Icon(
                                            Icons.arrow_forward_ios_sharp),
                                      ),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () => _showBankForm(
                                                id: banks[index].id,
                                                data: data),
                                            child: const Text('Edit'),
                                          ),
                                          TextButton(
                                            onPressed: () => _deleteBank(
                                                banks[index].id),
                                            child: const Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.red)),
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
        onPressed: _showBankForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BankDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const BankDetailsScreen({required this.data});

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Bank Details'),
      body: Stack(
        children: [
          ScreenBackground(context),
          SingleChildScrollView(
            padding: const EdgeInsets.all(6.0),
            child: Card(
              elevation: 10,
              margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: data['image'] != null
                          ? Image.network(
                        data['image'],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.account_balance,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildDetailsTile(
                      context,
                      icon: Icons.business_center,
                      title: 'Bank Name',
                      subtitle: data['name'] ?? 'Not available',
                      color: Colors.green,
                    ),
                    buildDetailsTile(
                      context,
                      icon: Icons.location_on,
                      title: 'Location',
                      subtitle: data['location'] ?? 'Not available',
                      color: Colors.orange,
                    ),
                    buildDetailsTile(
                      context,
                      icon: Icons.phone,
                      title: 'Contact',
                      subtitle: data['contact'] ?? 'Not available',
                      color: Colors.blue,
                    ),
                    buildDetailsTile(
                      context,
                      icon: Icons.web,
                      title: 'Website',
                      subtitle: data['website'] ?? 'Not available',
                      color: Colors.lightBlueAccent,
                      isLink: true,
                      onTap: () {
                        final url = data['website'];
                        if (url != null && url.isNotEmpty) {
                          _launchURL(url);
                        }
                      },
                    ),
                    buildDetailsTile(
                      context,
                      icon: Icons.email,
                      title: 'Email',
                      subtitle: data['email'] ?? 'Not available',
                      color: Colors.teal,
                    ),
                    buildDetailsTile(
                      context,
                      icon: Icons.description,
                      title: 'Description',
                      subtitle: data['description'] ?? 'Not available',
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailsTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        Color color = Colors.black,
        bool isLink = false,
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: isLink ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isLink ? Colors.blue : Colors.black87,
                      decoration: isLink ? TextDecoration.underline : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


