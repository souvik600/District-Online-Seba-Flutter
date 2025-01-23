import 'dart:io';
import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Styles/InputDecorationStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../AppColors/AppColors.dart';
import '../../../../../../Styles/ElevatedBottonStyle.dart';
import '../../../../../../Styles/TextContainerStyle.dart';
import '../../../../../../Utilitys/utilitys.dart';

class ReporterDataModels {
  final String id;
  final String name;
  final String specialization;
  final String contact;
  final String email;
  final String location;
  final String imageUrl;

  ReporterDataModels({
    required this.id,
    required this.name,
    required this.specialization,
    required this.contact,
    required this.email,
    required this.location,
    required this.imageUrl,
  });

  factory ReporterDataModels.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReporterDataModels(
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

class AdminReporterScreen extends StatefulWidget {
  @override
  _AdminReporterScreenState createState() => _AdminReporterScreenState();
}

class _AdminReporterScreenState extends State<AdminReporterScreen> {
  final List<ReporterDataModels> allReporter = [];
  List<ReporterDataModels> filteredReporter = [];

  @override
  void initState() {
    super.initState();
    fetchReporter();
  }

  void fetchReporter() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('ReporterList').get();
    final reporters = querySnapshot.docs
        .map((doc) => ReporterDataModels.fromFirestore(doc))
        .toList();
    setState(() {
      allReporter.addAll(reporters);
      filteredReporter.addAll(reporters);
    });
  }

  void filterReporters(String query) {
    setState(() {
      filteredReporter = allReporter
          .where((reporter) =>
              reporter.name.toLowerCase().contains(query.toLowerCase()) ||
              reporter.specialization
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _deleteReporter(String id, int index) async {
    await FirebaseFirestore.instance
        .collection('ReporterList')
        .doc(id)
        .delete();
    setState(() {
      filteredReporter.removeAt(index);
    });
  }

  void _editReporter(ReporterDataModels reporter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ReporterForm(
          reporter: reporter,
          onSubmit: (updatedReporter) {
            setState(() {
              int index = filteredReporter
                  .indexWhere((d) => d.id == updatedReporter.id);
              if (index != -1) {
                filteredReporter[index] = updatedReporter;
                allReporter[allReporter.indexWhere(
                    (d) => d.id == updatedReporter.id)] = updatedReporter;
              }
            });
          },
        );
      },
    );
  }

  void _addReporter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ReporterForm(
          onSubmit: (newReporter) {
            setState(() {
              filteredReporter.add(newReporter);
              allReporter.add(newReporter);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("সংবাদিক"),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReporter,
        child: const Icon(Icons.add),
        backgroundColor: AppColors.pColor,
      ),
      body: Stack(
        children: [
          ScreenBackground(context),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: filterReporters,
                  decoration: InputDecoration(
                    hintText: "Search Reporter...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredReporter.length,
                  itemBuilder: (context, index) {
                    return ReporterListItem(
                      reporter: filteredReporter[index],
                      onDelete: () =>
                          _deleteReporter(filteredReporter[index].id, index),
                      onEdit: () => _editReporter(filteredReporter[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReporterListItem extends StatelessWidget {
  final ReporterDataModels reporter;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  ReporterListItem({
    required this.reporter,
    required this.onDelete,
    required this.onEdit,
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
                    image: AssetImage('assets/icons/commentator.png'),
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
                border: Border.all(color: AppColors.pColor, width: 1.5),
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
                            border:
                                Border.all(color: AppColors.pColor, width: 2.0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: reporter.imageUrl.isNotEmpty
                                ? Image.network(
                                    reporter.imageUrl,
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
                        const SizedBox(
                          height: 4,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: Colors.teal,
                          ),
                          icon: const Icon(Icons.call,
                              size: 16, color: Colors.white),
                          label: const Text(
                            "Call",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          onPressed: () =>
                              showCallDialog(reporter.contact, context),
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
                              const Icon(Icons.person,
                                  size: 16, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  reporter.name,
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
                            reporter.specialization,
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
                                  size: 16, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  reporter.contact,
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
                              const Icon(Icons.email,
                                  size: 16, color: Colors.orange),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  reporter.email,
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
                                  size: 16, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  reporter.location,
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
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                tooltip: "Edit",
                                onPressed: onEdit,
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
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

class ReporterForm extends StatefulWidget {
  final ReporterDataModels? reporter;
  final Function(ReporterDataModels) onSubmit;

  ReporterForm({this.reporter, required this.onSubmit});

  @override
  _ReporterFormState createState() => _ReporterFormState();
}

class _ReporterFormState extends State<ReporterForm> {
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
          .child('reporter_images')
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

        final reporterData = {
          'name': _name!,
          'specialization': _specialization!,
          'contact': _contact!,
          'email': _email!,
          'location': _location!,
          'imageUrl': imageUrl ?? widget.reporter?.imageUrl ?? '',
        };

        if (widget.reporter == null) {
          // Add new doctor
          final docRef = await FirebaseFirestore.instance
              .collection('ReporterList')
              .add(reporterData);
          widget.onSubmit(
            ReporterDataModels(
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
              .collection('ReporterList')
              .doc(widget.reporter!.id)
              .update(reporterData);
          widget.onSubmit(
            ReporterDataModels(
              id: widget.reporter!.id,
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
                TextContainerStyle("Fill Up Reporter Form", AppColors.pColor),
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
                          icon: const Icon(Icons.add,
                              size: 50, color: Colors.grey),
                          onPressed: _pickImage,
                        )
                      : null,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  initialValue: widget.reporter?.name,
                  decoration: AppInputDecoration('Name'),
                  onSaved: (value) => _name = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Name is required"
                      : null,
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  initialValue: widget.reporter?.specialization,
                  decoration: AppInputDecoration('Specialization'),
                  onSaved: (value) => _specialization = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Specialization is required"
                      : null,
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  initialValue: widget.reporter?.contact,
                  decoration: AppInputDecoration('Contact'),
                  onSaved: (value) => _contact = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Contact is required"
                      : null,
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  initialValue: widget.reporter?.email,
                  decoration: AppInputDecoration('Email'),
                  onSaved: (value) => _email = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Email is required"
                      : null,
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  initialValue: widget.reporter?.location,
                  decoration: AppInputDecoration('Location'),
                  onSaved: (value) => _location = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Location is required"
                      : null,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButtonStyle(
                        text: "Submit", onPressed: _submitForm),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
