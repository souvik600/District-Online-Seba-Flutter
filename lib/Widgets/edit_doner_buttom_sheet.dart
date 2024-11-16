import 'package:flutter/material.dart';

import '../AppColors/AppColors.dart';
import '../Styles/InputDecorationStyle.dart';

class EditDonorBottomSheet extends StatefulWidget {
  final String name;
  final String contact;
  final String location;
  final String bloodGroup;
  final int age;
  final String availability;
  final String imageUrl;
  final Function(String, String, String, String, int, String, String) onSubmit;

  const EditDonorBottomSheet({
    required this.name,
    required this.contact,
    required this.location,
    required this.bloodGroup,
    required this.age,
    required this.availability,
    required this.imageUrl,
    required this.onSubmit,
  });

  @override
  _EditDonorBottomSheetState createState() => _EditDonorBottomSheetState();
}

class _EditDonorBottomSheetState extends State<EditDonorBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _locationController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _ageController;
  String? _availability;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _contactController = TextEditingController(text: widget.contact);
    _locationController = TextEditingController(text: widget.location);
    _bloodGroupController = TextEditingController(text: widget.bloodGroup);
    _ageController = TextEditingController(text: widget.age.toString());
    _availability = widget.availability;
    _imageUrl = widget.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _locationController.dispose();
    _bloodGroupController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Text(
            'Edit Donor Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.bColor,
            ),
          ),
          const SizedBox(height: 20),

          // Name field
          _buildTextField('Name', _nameController),

          // Contact field
          const SizedBox(height: 12),
          _buildTextField('Contact', _contactController),

          // Location field
          const SizedBox(height: 12),
          _buildTextField('Location', _locationController),

          // Blood Group field
          const SizedBox(height: 12),
          _buildTextField('Blood Group', _bloodGroupController),

          // Age field
          const SizedBox(height: 12),
          _buildTextField('Age', _ageController, isNumber: true),

          // Availability field
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Availability: ',
                style: TextStyle(fontSize: 16),
              ),
              DropdownButton<String>(
                value: _availability,
                onChanged: (value) {
                  setState(() {
                    _availability = value;
                  });
                },
                items: ['Available', 'Not Available'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Submit Button
          Center(

            child: ElevatedButton(
              onPressed: () {
                widget.onSubmit(
                  _nameController.text,
                  _contactController.text,
                  _locationController.text,
                  _bloodGroupController.text,
                  int.tryParse(_ageController.text) ?? 0,
                  _availability ?? 'Not Available',
                  _imageUrl ?? '',
                );
                Navigator.pop(context); // Close bottom sheet after submit
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: AppInputDecoration('Enter $label'),
          // decoration: InputDecoration(
          //   border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   hintText: 'Enter $label',
          // ),
        ),
      ],
    );
  }
}
