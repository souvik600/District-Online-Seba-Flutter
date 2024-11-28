import 'dart:io';
import 'package:district_online_service/Styles/InputDecorationStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../AppColors/AppColors.dart';

class AmbulanceDataModel {
  final String id;
  final String serviceName;
  final String contact;
  final bool isAvailable;
  final String location;
  final String imageUrl;
  final String ambulanceType;
  final String driverName;

  AmbulanceDataModel({
    required this.id,
    required this.serviceName,
    required this.contact,
    required this.isAvailable,
    required this.location,
    required this.imageUrl,
    required this.ambulanceType,
    required this.driverName,
  });

  factory AmbulanceDataModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AmbulanceDataModel(
      id: doc.id,
      serviceName: data['serviceName'] ?? '',
      contact: data['contact'] ?? '',
      isAvailable: data['isAvailable'] ?? false,
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      ambulanceType: data['ambulanceType'] ?? '',
      driverName: data['driverName'] ?? '',
    );
  }
}

class AdminAmbulanceServiceScreen extends StatefulWidget {
  @override
  _AdminAmbulanceServiceScreenState createState() =>
      _AdminAmbulanceServiceScreenState();
}

class _AdminAmbulanceServiceScreenState
    extends State<AdminAmbulanceServiceScreen> {
  final List<AmbulanceDataModel> allAmbulances = [];
  List<AmbulanceDataModel> filteredAmbulances = [];

  @override
  void initState() {
    super.initState();
    fetchAmbulances();
  }

  void fetchAmbulances() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('AmbulanceList').get();
    final ambulances = querySnapshot.docs
        .map((doc) => AmbulanceDataModel.fromFirestore(doc))
        .toList();
    setState(() {
      allAmbulances.addAll(ambulances);
      filteredAmbulances.addAll(ambulances);
    });
  }

  void filterAmbulances(String query) {
    setState(() {
      filteredAmbulances = allAmbulances
          .where((ambulance) =>
              ambulance.serviceName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _deleteAmbulance(String id, int index) async {
    await FirebaseFirestore.instance
        .collection('AmbulanceList')
        .doc(id)
        .delete();
    setState(() {
      filteredAmbulances.removeAt(index);
    });
  }

  void _editAmbulance(AmbulanceDataModel ambulance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AmbulanceForm(
          ambulance: ambulance,
          onSubmit: (updatedAmbulance) {
            setState(() {
              int index = filteredAmbulances
                  .indexWhere((a) => a.id == updatedAmbulance.id);
              if (index != -1) {
                filteredAmbulances[index] = updatedAmbulance;
                allAmbulances[allAmbulances.indexWhere(
                    (a) => a.id == updatedAmbulance.id)] = updatedAmbulance;
              }
            });
          },
        );
      },
    );
  }

  void _addAmbulance() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AmbulanceForm(
          onSubmit: (newAmbulance) {
            setState(() {
              filteredAmbulances.add(newAmbulance);
              allAmbulances.add(newAmbulance);
            });
          },
        );
      },
    );
  }

  Future<void> _makeCall(String contact) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: contact,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Ambulance Services'),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAmbulance,
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterAmbulances,
              decoration: InputDecoration(
                hintText: "Search Ambulance Services...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAmbulances.length,
              itemBuilder: (context, index) {
                final ambulance = filteredAmbulances[index];

                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/icons/ambulance.png'),
                              fit: BoxFit.contain,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 8,
                      color: AppColors.wColor.withOpacity(.92),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.pColor, width: 1.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Service Name and Location
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.pColor, width: 1.5),
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.pColor.withOpacity(.3)),
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      ambulance.serviceName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: AppColors.pColor,
                                      ),
                                      Text(
                                        ambulance.location,
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            // Row with Image and Details
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image Section
                                  ambulance.imageUrl.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            ambulance.imageUrl,
                                            fit: BoxFit.cover,
                                            width: 80,
                                            height: 80,
                                          ),
                                        )
                                      : Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: const Icon(
                                              Icons.local_hospital,
                                              size: 40),
                                        ),
                                  const SizedBox(width: 16),

                                  // Details Section
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Driver: ${ambulance.driverName}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "Type: ${ambulance.ambulanceType}",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "Phone: ${ambulance.contact}",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          ambulance.isAvailable
                                              ? "Available"
                                              : "Not Available",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: ambulance.isAvailable
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Action Buttons
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        _makeCall(ambulance.contact),
                                    icon: const Icon(Icons.call,
                                        color: Colors.white),
                                    label: const Text("Call"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () => _editAmbulance(ambulance),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _deleteAmbulance(ambulance.id, index),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AmbulanceForm extends StatefulWidget {
  final AmbulanceDataModel? ambulance;
  final Function(AmbulanceDataModel) onSubmit;

  AmbulanceForm({this.ambulance, required this.onSubmit});

  @override
  _AmbulanceFormState createState() => _AmbulanceFormState();
}

class _AmbulanceFormState extends State<AmbulanceForm> {
  final _formKey = GlobalKey<FormState>();
  String? _serviceName,
      _contact,
      _location,
      _imageUrl,
      _ambulanceType,
      _driverName;
  bool _isAvailable = false;
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
          .child('ambulance_images')
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
        String? imageUrl = _imageUrl;
        if (_selectedImage != null) {
          imageUrl = await _uploadImage(_selectedImage!);
        }

        final ambulanceData = {
          'serviceName': _serviceName!,
          'contact': _contact!,
          'isAvailable': _isAvailable,
          'location': _location!,
          'imageUrl': imageUrl ?? '',
          'ambulanceType': _ambulanceType!,
          'driverName': _driverName!,
        };

        if (widget.ambulance != null) {
          // Update existing ambulance
          await FirebaseFirestore.instance
              .collection('AmbulanceList')
              .doc(widget.ambulance!.id)
              .update(ambulanceData);
          widget.onSubmit(AmbulanceDataModel(
            id: widget.ambulance!.id,
            serviceName: _serviceName!,
            contact: _contact!,
            isAvailable: _isAvailable,
            location: _location!,
            imageUrl: imageUrl ?? '',
            ambulanceType: _ambulanceType!,
            driverName: _driverName!,
          ));
        } else {
          // Add new ambulance
          final docRef = await FirebaseFirestore.instance
              .collection('AmbulanceList')
              .add(ambulanceData);
          widget.onSubmit(AmbulanceDataModel(
            id: docRef.id,
            serviceName: _serviceName!,
            contact: _contact!,
            isAvailable: _isAvailable,
            location: _location!,
            imageUrl: imageUrl ?? '',
            ambulanceType: _ambulanceType!,
            driverName: _driverName!,
          ));
        }
        Navigator.of(context).pop();
      } catch (e) {
        print("Error saving ambulance: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_isLoading) CircularProgressIndicator(),
              if (!_isLoading) ...[
                TextFormField(
                  initialValue: widget.ambulance?.serviceName,
                  decoration: AppInputDecoration('Ambulance Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a Ambulance name' : null,
                  onSaved: (value) => _serviceName = value,
                ),
                TextFormField(
                  initialValue: widget.ambulance?.contact,
                  decoration: AppInputDecoration('Contact'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a contact number' : null,
                  onSaved: (value) => _contact = value,
                ),
                TextFormField(
                  initialValue: widget.ambulance?.location,
                  decoration: AppInputDecoration('Location'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a location' : null,
                  onSaved: (value) => _location = value,
                ),
                TextFormField(
                  initialValue: widget.ambulance?.ambulanceType,
                  decoration: AppInputDecoration('Ambulance Type'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter ambulance type' : null,
                  onSaved: (value) => _ambulanceType = value,
                ),
                TextFormField(
                  initialValue: widget.ambulance?.driverName,
                  decoration: AppInputDecoration('Driver Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter driver name' : null,
                  onSaved: (value) => _driverName = value,
                ),
                SwitchListTile(
                  title: const Text("Available"),
                  value: _isAvailable,
                  onChanged: (value) => setState(() {
                    _isAvailable = value;
                  }),
                ),
                const SizedBox(height: 8),
                _selectedImage != null
                    ? Image.file(
                        File(_selectedImage!.path),
                        height: 150,
                      )
                    : widget.ambulance?.imageUrl != null &&
                            widget.ambulance!.imageUrl.isNotEmpty
                        ? Image.network(
                            widget.ambulance!.imageUrl,
                            height: 150,
                          )
                        : const Icon(Icons.image, size: 100),
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Select Image"),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pColor.withOpacity(.8),
                      padding: EdgeInsets.symmetric(vertical: 12.0), // Padding for the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: Text(widget.ambulance != null ? "Update" : "Add"),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
