import 'dart:io';
import 'package:district_online_service/AppColors/AppColors.dart';
import 'package:district_online_service/Styles/InputDecorationStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../Styles/BackGroundStyle.dart';

class AdminHospitalScreen extends StatefulWidget {
  @override
  _AdminHospitalScreenState createState() => _AdminHospitalScreenState();
}

class _AdminHospitalScreenState extends State<AdminHospitalScreen> {
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

  // Add hospital
  Future<void> _addHospital() async {
    final data = {
      'name': _nameController.text.trim(),
      'location': _locationController.text.trim(),
      'contact': _contactController.text.trim(),
      'description': _descriptionController.text.trim(),
      'website': _websiteController.text.trim(),
      'email': _emailController.text.trim(),
    };

    final docRef = await _firestore.collection('hospitals').add(data);
    if (_selectedImage != null) {
      final imageUrl = await _uploadImage(docRef.id);
      await docRef.update({'image': imageUrl});
    }

    Navigator.of(context).pop(); // Close bottom sheet
  }

  // Update hospital
  Future<void> _updateHospital(String id) async {
    final data = {
      'name': _nameController.text.trim(),
      'location': _locationController.text.trim(),
      'contact': _contactController.text.trim(),
      'description': _descriptionController.text.trim(),
      'website': _websiteController.text.trim(),
      'email': _emailController.text.trim(),
    };

    // Update the existing hospital with new data
    await _firestore.collection('hospitals').doc(id).update(data);

    // If image was changed, upload it and update the image field
    if (_selectedImage != null) {
      final imageUrl = await _uploadImage(id);
      await _firestore
          .collection('hospitals')
          .doc(id)
          .update({'image': imageUrl});
    }

    Navigator.of(context).pop(); // Close bottom sheet
  }

  // Upload image
  Future<String> _uploadImage(String id) async {
    final ref = _storage.ref().child('hospital_images/$id.jpg');
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

  Future<void> _deleteHospital(String id) async {
    await _firestore.collection('hospitals').doc(id).delete();
  }

  // Show form for adding or editing hospital
  void _showHospitalForm({String? id, Map<String, dynamic>? data}) {
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
                    data == null ? 'Add Hospital' : 'Edit Hospital',
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
                      decoration: AppInputDecoration('Hospital Name')),
                  const SizedBox(height: 8.0),
                  TextField(
                      controller: _locationController,
                      decoration: AppInputDecoration('Hospital Location')),
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
                          _addHospital(); // Add hospital if data is null
                        } else {
                          _updateHospital(
                              id!); // Update hospital if data is provided
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pColor.withOpacity(.8),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: Text(
                          data == null ? 'Add Hospital' : 'Update Hospital',
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
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => HospitalDetailsScreen(data: data)));
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
      appBar: CustomAppBar('Hospital'),
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
                  hintText: 'Search Hospital by Name or Location',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _firestore
                    .collection('hospitals')
                    .where('name', isGreaterThanOrEqualTo: _searchQuery)
                    .where('name', isLessThanOrEqualTo: _searchQuery + '\uf8ff')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final hospitals = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: hospitals.length,
                    itemBuilder: (context, index) {
                      final data = hospitals[index].data();
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
                                      AssetImage('assets/icons/doctor.png'),
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
                                          onPressed: () => _showHospitalForm(id: hospitals[index].id, data: data),
                                          child: const Text('Edit'),
                                        ),
                                        TextButton(
                                          onPressed: () => _deleteHospital(hospitals[index].id),
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
        onPressed: () => _showHospitalForm(),
        backgroundColor: AppColors.pColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HospitalDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  HospitalDetailsScreen({required this.data});

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _callPhone(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not place call';
    }
  }

  Future<void> _sendEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not send email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          data['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.pColor, Colors.blue.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Gradient Overlay
            _buildImageSection(),
            const SizedBox(height: 10),
            // Hospital Name & Location
            _buildHospitalNameAndLocation(),
            const SizedBox(height: 10),
            // Contact Info Card (Phone, Email, Website)
            _buildContactCard(),
            const SizedBox(height: 10),
            // Description Card
            _buildDescriptionCard(),
          ],
        ),
      ),
    );
  }

  // Image Section with Gradient Overlay
  Widget _buildImageSection() {
    return Stack(
      children: [
        data['image'] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  data['image'],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Icon(
                  Icons.local_hospital,
                  size: 100,
                  color: Colors.grey[700],
                ),
              ),
        // Gradient Overlay for Image
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Hospital Name and Location
  // Hospital Name and Location
  Widget _buildHospitalNameAndLocation() {
    return Card(
      elevation: 12,
      color: AppColors.pColor.withOpacity(.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center text in the Card
        children: [
          const SizedBox(height: 5),
          // Hospital Name
          Center(
            child: Text(
              data['name'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.pColor
              ),
            ),
          ),
          const SizedBox(height: 5),
          // Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.location_on_outlined,color: Colors.red,),
              SizedBox(width: 5,),
              Expanded(
                child: Text(
                  data['location'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
  // Contact Info Card with Buttons at the Bottom
  Widget _buildContactCard() {
    return Card(
      elevation: 12,
      color: AppColors.sdColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.4),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Title
            const Center(
              child: Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pColor
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Contact Information List with Icons
            _buildContactItem(Icons.phone, 'Phone', data['contact']),
            const SizedBox(height: 15),

            _buildContactItem(Icons.email, 'Email', data['email']),
            const SizedBox(height: 15),

            GestureDetector(
              onTap: () => _launchURL(data['website']),
              child:
                  _buildContactItem(Icons.language, 'Website', data['website']),
            ),

            const SizedBox(height: 20),

            // Buttons at the Bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Call Button
                _buildContactButton(Icons.phone, 'Call',
                    () => _callPhone(data['contact']), Colors.green),

                // Email Button
                _buildContactButton(Icons.email, 'Email',
                    () => _sendEmail(data['email']), Colors.blue),

                // Website Button
                _buildContactButton(Icons.language, 'Website',
                    () => _launchURL(data['website']), Colors.blueAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each contact item (Phone, Email, Website)
  Widget _buildContactItem(IconData icon, String title, String content) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '$title: $content',
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  // Contact Buttons (Call, Email, Website)
  Widget _buildContactButton(
      IconData icon, String label, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.black.withOpacity(0.3),
        elevation: 8,
      ),
    );
  }
  // Description Card
  Widget _buildDescriptionCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.4),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description Title
            const Center(
              child: Text(
                'About Hospital',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pColor
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Description Text
            Text(
              data['description'],
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
