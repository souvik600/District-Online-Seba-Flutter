import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:district_online_service/Screens/UsersPanel/UsersCategoryScreen/EmargencyServiceCategory/BloodDonerListScreen/data_models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../AppColors/AppColors.dart';
import '../../../../../Styles/ElevatedBottonStyle.dart';
import '../../../../../Styles/InputDecorationStyle.dart';
import '../../../../../Styles/TextContainerStyle.dart';

class EditDonarFormScreen extends StatefulWidget {
  BloodDonorModels donor;

  EditDonarFormScreen({required this.donor});

  @override
  _EditDonarFormScreenState createState() => _EditDonarFormScreenState();
}

class _EditDonarFormScreenState extends State<EditDonarFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _ageController;
  late TextEditingController _contactController;
  String? _bloodGroup;
  String? _availability; // Availability as String: 'Available' or 'Not Available'
  XFile? _imageFile;
  final _picker = ImagePicker();

  // List of blood groups
  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  // List of availability options
  final List<String> _availabilityOptions = ['Available', 'Not Available'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.donor.name);
    _bloodGroup = widget.donor.bloodGroup;
    _locationController = TextEditingController(text: widget.donor.location);
    _ageController = TextEditingController(text: widget.donor.age.toString());
    _contactController = TextEditingController(text: widget.donor.contact);
    // Initialize availability based on the donor's status from Firebase
    _availability = (widget.donor.availability ?? 'Not Available') as String?;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _ageController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _updateDonor() async {
    if (_formKey.currentState!.validate()) {
      // Upload new image if selected
      String? imageUrl;
      if (_imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('blood_donor_avatars')
            .child(_imageFile!.name);
        await ref.putFile(File(_imageFile!.path));
        imageUrl = await ref.getDownloadURL();
      }

      // Update donor data in Firestore
      await FirebaseFirestore.instance.collection('blood_donors').doc(widget.donor.id).update({
        'name': _nameController.text,
        'bloodGroup': _bloodGroup,
        'location': _locationController.text,
        'age': int.parse(_ageController.text),
        'contact': _contactController.text,
        'availability': _availability, // Save the availability string ('Available' or 'Not Available')
        if (imageUrl != null) 'image_url': imageUrl,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.pColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 5),
                TextContainerStyle("Edit Blood Donor Form", AppColors.pColor),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                      image: _imageFile == null
                          ? DecorationImage(
                        image: NetworkImage(widget.donor.image_url), // Existing image URL
                        fit: BoxFit.cover,
                      )
                          : DecorationImage(
                        image: FileImage(File(_imageFile!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: _imageFile == null
                        ? const Icon(Icons.add, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nameController,
                  decoration: AppInputDecoration('Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: AppInputDecoration('Blood Group'),
                  items: _bloodGroups.map((bloodGroup) {
                    return DropdownMenuItem<String>(
                      value: bloodGroup,
                      child: Text(bloodGroup),
                    );
                  }).toList(),
                  value: _bloodGroup,
                  validator: (value) => value == null ? 'Please select a blood group' : null,
                  onChanged: (value) => setState(() {
                    _bloodGroup = value; // Update the blood group
                  }),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _locationController,
                  decoration: AppInputDecoration('Location'),
                  validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _ageController,
                  decoration: AppInputDecoration('Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter an age' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _contactController,
                  decoration: AppInputDecoration('Contact'),
                  validator: (value) => value!.isEmpty ? 'Please enter a contact number' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: AppInputDecoration('Availability'),
                  value: _availability, // Use the value fetched from Firebase
                  items: _availabilityOptions.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _availability = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButtonStyle(
                  text: "Update Donor",
                  onPressed: _updateDonor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
