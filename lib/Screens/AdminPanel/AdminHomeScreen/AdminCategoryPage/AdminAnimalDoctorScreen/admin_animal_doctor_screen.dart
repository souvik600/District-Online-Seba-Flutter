import 'dart:io';
import 'package:district_online_service/Styles/InputDecorationStyle.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../AppColors/AppColors.dart';
import '../../../../../Styles/ElevatedBottonStyle.dart';
import '../../../../../Styles/TextContainerStyle.dart';

class DoctorDataModels {
  final String id;
  final String name;
  final String specialization;
  final String contact;
  final String email;
  final String location;
  final String imageUrl;

  DoctorDataModels({
    required this.id,
    required this.name,
    required this.specialization,
    required this.contact,
    required this.email,
    required this.location,
    required this.imageUrl,
  });

  factory DoctorDataModels.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DoctorDataModels(
      id: doc.id,
      name: data['name'] ?? '',
      specialization: data['specialization'] ?? '',
      contact: data['contact'] ?? '',
      email: data['email'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}

class AdminAnimalDoctorScreen extends StatefulWidget {
  @override
  _AdminAnimalDoctorScreenState createState() => _AdminAnimalDoctorScreenState();
}

class _AdminAnimalDoctorScreenState extends State<AdminAnimalDoctorScreen> {
  final List<DoctorDataModels> allDoctors = [];
  List<DoctorDataModels> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  void fetchDoctors() async {
    final querySnapshot =
    await FirebaseFirestore.instance.collection('AnimalDoctorList').get();
    final doctors = querySnapshot.docs
        .map((doc) => DoctorDataModels.fromFirestore(doc))
        .toList();
    setState(() {
      allDoctors.addAll(doctors);
      filteredDoctors.addAll(doctors);
    });
  }

  void filterDoctors(String query) {
    setState(() {
      filteredDoctors = allDoctors
          .where((doctor) =>
      doctor.name.toLowerCase().contains(query.toLowerCase()) ||
          doctor.specialization.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _deleteDoctor(String id, int index) async {
    await FirebaseFirestore.instance.collection('AnimalDoctorList').doc(id).delete();
    setState(() {
      filteredDoctors.removeAt(index);
    });
  }

  void _editDoctor(DoctorDataModels doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DoctorForm(
          doctor: doctor,
          onSubmit: (updatedDoctor) {
            setState(() {
              int index =
              filteredDoctors.indexWhere((d) => d.id == updatedDoctor.id);
              if (index != -1) {
                filteredDoctors[index] = updatedDoctor;
                allDoctors[allDoctors.indexWhere((d) => d.id == updatedDoctor.id)] =
                    updatedDoctor;
              }
            });
          },
        );
      },
    );
  }

  void _addDoctor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DoctorForm(
          onSubmit: (newDoctor) {
            setState(() {
              filteredDoctors.add(newDoctor);
              allDoctors.add(newDoctor);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animal Doctors"),
        backgroundColor: AppColors.pColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDoctor,
        child: const Icon(Icons.add),
        backgroundColor: AppColors.pColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterDoctors,
              decoration: InputDecoration(
                hintText: "Search Doctors...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                return DoctorListItem(
                  doctor: filteredDoctors[index],
                  onDelete: () => _deleteDoctor(filteredDoctors[index].id, index),
                  onEdit: () => _editDoctor(filteredDoctors[index]),
                  onSendEmail: () {  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorListItem extends StatelessWidget {
  final DoctorDataModels doctor;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onSendEmail;

  DoctorListItem({
    required this.doctor,
    required this.onDelete,
    required this.onEdit,
    required this.onSendEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image:
                    AssetImage('assets/icons/medical.png'),
                    fit: BoxFit.contain,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Card(
            elevation: 5,
            color: AppColors.wColor.withOpacity(.8),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            borderRadius: BorderRadius.circular(10.0),
                            child: doctor.imageUrl.isNotEmpty
                                ? Image.network(
                              doctor.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                                : Image.asset(
                              'assets/images/user.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 4,),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: Colors.teal,
                          ),
                          icon: const Icon(Icons.call, size: 16, color: Colors.white),
                          label: const Text(
                            "Call",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          onPressed: onSendEmail,
                        ),
                      ],
                    ),
                    const SizedBox(width: 12.0),
                    // Details Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and Specialization
                          Row(
                            children: [
                              const Icon(Icons.person, size: 16, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  doctor.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doctor.specialization,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black45,
                            ),
                          ),
                          const Divider(),
                          // Contact Information
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 16, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  doctor.contact,
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
                              const Icon(Icons.email, size: 16, color: Colors.orange),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  doctor.email,
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
                              const Icon(Icons.location_on, size: 16, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  doctor.location,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Action Buttons Section
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                tooltip: "Edit",
                                onPressed: onEdit,
                              ),
                              SizedBox(width: 30,),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: "Delete",
                                onPressed: onDelete,
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class DoctorForm extends StatefulWidget {
  final DoctorDataModels? doctor;
  final Function(DoctorDataModels) onSubmit;

  DoctorForm({this.doctor, required this.onSubmit});

  @override
  _DoctorFormState createState() => _DoctorFormState();
}

class _DoctorFormState extends State<DoctorForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _specialization, _contact, _email, _location, _imageUrl;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  Future<String?> _uploadImage(XFile image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('animal_doctor_images')
          .child('${DateTime.now().toIso8601String()}.jpg');
      await ref.putFile(File(image.path));
      return await ref.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        // Upload image if a new image is selected
        String? imageUrl = _imageUrl;
        if (_selectedImage != null) {
          imageUrl = await _uploadImage(_selectedImage!);
        }

        final doctorData = {
          'name': _name!,
          'specialization': _specialization!,
          'contact': _contact!,
          'email': _email!,
          'location': _location!,
          'imageUrl': imageUrl ?? widget.doctor?.imageUrl ?? '',
        };

        if (widget.doctor == null) {
          // Add new doctor
          final docRef = await FirebaseFirestore.instance
              .collection('AnimalDoctorList')
              .add(doctorData);
          widget.onSubmit(
            DoctorDataModels(
              id: docRef.id,
              name: _name!,
              specialization: _specialization!,
              contact: _contact!,
              email: _email!,
              location: _location!,
              imageUrl: imageUrl ?? '',
            ),
          );
        } else {
          // Update existing doctor
          await FirebaseFirestore.instance
              .collection('AnimalDoctorList')
              .doc(widget.doctor!.id)
              .update(doctorData);
          widget.onSubmit(
            DoctorDataModels(
              id: widget.doctor!.id,
              name: _name!,
              specialization: _specialization!,
              contact: _contact!,
              email: _email!,
              location: _location!,
              imageUrl: imageUrl ?? '',
            ),
          );
        }

        Navigator.of(context).pop();
      } catch (e) {
        print("Error saving doctor: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 5),
                TextContainerStyle("Fill Up Animal Doctor Form", AppColors.pColor),
                const SizedBox(height: 10),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                    image: _selectedImage == null
                        ? const DecorationImage(
                      image: AssetImage('assets/images/user.png'),
                      fit: BoxFit.contain,
                    )
                        : DecorationImage(
                      image: FileImage(File(_selectedImage!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: _selectedImage == null
                      ? IconButton(
                    icon: const Icon(Icons.add, size: 50, color: Colors.grey),
                    onPressed: _pickImage,
                  )
                      : null,
                ),
                SizedBox(height: 8,),
                TextFormField(
                  initialValue: widget.doctor?.name,
                  decoration: AppInputDecoration('Name'),
                  onSaved: (value) => _name = value,
                  validator: (value) =>
                  value == null || value.isEmpty ? "Name is required" : null,
                ),
                SizedBox(height: 6,),
                TextFormField(
                  initialValue: widget.doctor?.specialization,
                  decoration: AppInputDecoration('Specialization'),
                  onSaved: (value) => _specialization = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Specialization is required"
                      : null,
                ),
                SizedBox(height: 6,),
                TextFormField(
                  initialValue: widget.doctor?.contact,
                  decoration: AppInputDecoration('Contact'),
                  onSaved: (value) => _contact = value,
                  validator: (value) =>
                  value == null || value.isEmpty ? "Contact is required" : null,
                ),
                SizedBox(height: 6,),
                TextFormField(
                  initialValue: widget.doctor?.email,
                  decoration: AppInputDecoration('Email'),
                  onSaved: (value) => _email = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Email is required"
                      : null,
                ),
                SizedBox(height: 6,),
                TextFormField(
                  initialValue: widget.doctor?.location,
                  decoration: AppInputDecoration('Location'),
                  onSaved: (value) => _location = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Location is required"
                      : null,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButtonStyle(text: "Submit", onPressed: _submitForm),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

