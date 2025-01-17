import 'dart:io';
import 'package:district_online_service/Styles/InputDecorationStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../AppColors/AppColors.dart';
class TruckRentDataModel {
  final String id;
  final String serviceName;
  final String contact;
  final bool isAvailable;
  final String location;
  final String imageUrl;
  final String truckType;
  final String driverName;

  TruckRentDataModel({
    required this.id,
    required this.serviceName,
    required this.contact,
    required this.isAvailable,
    required this.location,
    required this.imageUrl,
    required this.truckType,
    required this.driverName,
  });

  factory TruckRentDataModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TruckRentDataModel(
      id: doc.id,
      serviceName: data['serviceName'] ?? '',
      contact: data['contact'] ?? '',
      isAvailable: data['isAvailable'] ?? false,
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      truckType: data['truckType'] ?? '',
      driverName: data['driverName'] ?? '',
    );
  }
}

class AdminTruckRentServiceScreen extends StatefulWidget {
  @override
  _AdminTruckRentServiceScreenState createState() =>
      _AdminTruckRentServiceScreenState();
}

class _AdminTruckRentServiceScreenState
    extends State<AdminTruckRentServiceScreen> {
  final List<TruckRentDataModel> allTruckRents = [];
  List<TruckRentDataModel> filteredTruckRents = [];

  @override
  void initState() {
    super.initState();
    fetchTruckRents();
  }

  void fetchTruckRents() async {
    final querySnapshot =
    await FirebaseFirestore.instance.collection('TruckRentList').get();
    final truckRents = querySnapshot.docs
        .map((doc) => TruckRentDataModel.fromFirestore(doc))
        .toList();
    setState(() {
      allTruckRents.addAll(truckRents);
      filteredTruckRents.addAll(truckRents);
    });
  }

  void filterTruckRents(String query) {
    setState(() {
      filteredTruckRents = allTruckRents
          .where((truck) =>
          truck.serviceName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _deleteTruckRent(String id, int index) async {
    await FirebaseFirestore.instance
        .collection('TruckRentList')
        .doc(id)
        .delete();
    setState(() {
      filteredTruckRents.removeAt(index);
    });
  }

  void _editTruckRent(TruckRentDataModel truck) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TruckRentForm(
          truckRent: truck,
          onSubmit: (updatedTruck) {
            setState(() {
              int index = filteredTruckRents
                  .indexWhere((t) => t.id == updatedTruck.id);
              if (index != -1) {
                filteredTruckRents[index] = updatedTruck;
                allTruckRents[allTruckRents.indexWhere(
                        (t) => t.id == updatedTruck.id)] = updatedTruck;
              }
            });
          },
        );
      },
    );
  }

  void _addTruckRent() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TruckRentForm(
          onSubmit: (newTruck) {
            setState(() {
              filteredTruckRents.add(newTruck);
              allTruckRents.add(newTruck);
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
      appBar: CustomAppBar('Truck Rent Services'),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTruckRent,
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterTruckRents,
              decoration: InputDecoration(
                hintText: "Search Truck Rent Services...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTruckRents.length,
              itemBuilder: (context, index) {
                final truck = filteredTruckRents[index];

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
                              image: AssetImage('assets/icons/shipment.png'),
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
                                      truck.serviceName,
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
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: AppColors.pColor,
                                      ),
                                      Text(
                                        truck.location,
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  truck.imageUrl.isNotEmpty
                                      ? ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                    child: Image.network(
                                      truck.imageUrl,
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
                                    child: const Icon(Icons.local_shipping,
                                        size: 40),
                                  ),
                                  const SizedBox(width: 16),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Driver: ${truck.driverName}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "Type: ${truck.truckType}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "Phone: ${truck.contact}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          truck.isAvailable
                                              ? "Available"
                                              : "Not Available",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: truck.isAvailable
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

                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.pColor.withOpacity(.1)),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        _makeCall(truck.contact),
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
                                    onPressed: () => _editTruckRent(truck),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _deleteTruckRent(truck.id, index),
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



class TruckRentForm extends StatefulWidget {
  final TruckRentDataModel? truckRent;
  final Function(TruckRentDataModel) onSubmit;

  TruckRentForm({this.truckRent, required this.onSubmit});

  @override
  _TruckRentFormState createState() => _TruckRentFormState();
}

class _TruckRentFormState extends State<TruckRentForm> {
  final _formKey = GlobalKey<FormState>();
  String? _serviceName, _contact, _location, _imageUrl, _truckType, _driverName;
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
          .child('truck_rent_images')
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

        final truckRentData = {
          'serviceName': _serviceName!,
          'contact': _contact!,
          'isAvailable': _isAvailable,
          'location': _location!,
          'imageUrl': imageUrl ?? '',
          'truckType': _truckType!,
          'driverName': _driverName!,
        };

        if (widget.truckRent != null) {
          // Update existing truck rent
          await FirebaseFirestore.instance
              .collection('TruckRentList')
              .doc(widget.truckRent!.id)
              .update(truckRentData);
          widget.onSubmit(TruckRentDataModel(
            id: widget.truckRent!.id,
            serviceName: _serviceName!,
            contact: _contact!,
            isAvailable: _isAvailable,
            location: _location!,
            imageUrl: imageUrl ?? '',
            truckType: _truckType!,
            driverName: _driverName!,
          ));
        } else {
          // Add new truck rent
          final docRef = await FirebaseFirestore.instance
              .collection('TruckRentList')
              .add(truckRentData);
          widget.onSubmit(TruckRentDataModel(
            id: docRef.id,
            serviceName: _serviceName!,
            contact: _contact!,
            isAvailable: _isAvailable,
            location: _location!,
            imageUrl: imageUrl ?? '',
            truckType: _truckType!,
            driverName: _driverName!,
          ));
        }
        Navigator.of(context).pop();
      } catch (e) {
        print("Error saving truck rent: $e");
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
              if (_isLoading) const CircularProgressIndicator(),
              if (!_isLoading) ...[
                TextFormField(
                  initialValue: widget.truckRent?.serviceName,
                  decoration: AppInputDecoration('Truck Rent Service Name'),
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter a service name' : null,
                  onSaved: (value) => _serviceName = value,
                ),
                TextFormField(
                  initialValue: widget.truckRent?.contact,
                  decoration: AppInputDecoration('Contact'),
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter a contact number' : null,
                  onSaved: (value) => _contact = value,
                ),
                TextFormField(
                  initialValue: widget.truckRent?.location,
                  decoration: AppInputDecoration('Location'),
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter a location' : null,
                  onSaved: (value) => _location = value,
                ),
                TextFormField(
                  initialValue: widget.truckRent?.truckType,
                  decoration: AppInputDecoration('Truck Type'),
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter truck type' : null,
                  onSaved: (value) => _truckType = value,
                ),
                TextFormField(
                  initialValue: widget.truckRent?.driverName,
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
                    : widget.truckRent?.imageUrl != null &&
                    widget.truckRent!.imageUrl.isNotEmpty
                    ? Image.network(
                  widget.truckRent!.imageUrl,
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
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: Text(widget.truckRent != null ? "Update" : "Add"),
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


