import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../AppColors/AppColors.dart';
import '../../../../../Styles/ElevatedBottonStyle.dart';
import '../../../../../Styles/TextContainerStyle.dart';

class AdminBloodDonorForm extends StatefulWidget {
  @override
  _AdminBloodDonorFormState createState() => _AdminBloodDonorFormState();
}

class _AdminBloodDonorFormState extends State<AdminBloodDonorForm> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  XFile? _imageFile;
  String? _name, _contact, _location, _bloodGroup;
  int? _age;
  bool _isLoading = false;

  List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  List<String> _availabilityOptions = ['Available', 'Not Available'];
  String? _availability = 'Available'; // Default to 'Available'

  // Pick image method remains the same as before
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> addBloodDonor() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _isLoading = true;
        });

        try {
          String? imageUrl;
          if (_imageFile != null) {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('blood_donor_avatars/${user.uid}.jpg');
            await storageRef.putFile(File(_imageFile!.path));
            imageUrl = await storageRef.getDownloadURL();
          }

          await FirebaseFirestore.instance
              .collection('blood_donors')
              .doc(user.uid)
              .set({
            'name': _name,
            'contact': _contact,
            'location': _location,
            'bloodGroup': _bloodGroup,
            'age': _age,
            'availability': _availability,
            'image_url': imageUrl,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Blood donor added successfully!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        } finally {
          setState(() {
            _isLoading = false;
            _imageFile = null;
          });
          _formKey.currentState!.reset();
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add a blood donor')),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
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
                TextContainerStyle("Fill Up Blood Donor Form", AppColors.pColor),
                const SizedBox(height: 10),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                    image: _imageFile == null
                        ? const DecorationImage(
                      image: AssetImage('assets/images/default_profile.png'),
                      fit: BoxFit.contain,
                    )
                        : DecorationImage(
                      image: FileImage(File(_imageFile!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: _imageFile == null
                      ? IconButton(
                    icon: const Icon(Icons.add, size: 50, color: Colors.grey),
                    onPressed: _pickImage,
                  )
                      : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: _inputDecoration('Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter name' : null,
                  onSaved: (value) => _name = value,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: _inputDecoration('Contact'),
                  validator: (value) => value!.isEmpty ? 'Please enter contact' : null,
                  onSaved: (value) => _contact = value,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: _inputDecoration('Location'),
                  validator: (value) => value!.isEmpty ? 'Please enter location' : null,
                  onSaved: (value) => _location = value,
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Blood Group'),
                  items: _bloodGroups.map((bloodGroup) {
                    return DropdownMenuItem<String>(
                      value: bloodGroup,
                      child: Text(bloodGroup),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Please select blood group' : null,
                  onChanged: (value) => setState(() {
                    _bloodGroup = value;
                  }),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: _inputDecoration('Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter age';
                    final age = int.tryParse(value);
                    if (age == null || age < 18 || age > 60) {
                      return 'Age must be between 18 and 60';
                    }
                    return null;
                  },
                  onSaved: (value) => _age = int.tryParse(value!),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Availability'),
                  value: _availability,
                  items: _availabilityOptions.map((availability) {
                    return DropdownMenuItem<String>(
                      value: availability,
                      child: Text(availability),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() {
                    _availability = value;
                  }),
                  validator: (value) => value == null ? 'Please select availability' : null,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButtonStyle(text: "Submit", onPressed: addBloodDonor),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

