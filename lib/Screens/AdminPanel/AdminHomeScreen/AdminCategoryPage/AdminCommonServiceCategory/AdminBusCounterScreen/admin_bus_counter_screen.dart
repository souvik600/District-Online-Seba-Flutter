import 'dart:io';
import 'package:district_online_service/Styles/InputDecorationStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../AppColors/AppColors.dart';

class BusCounterDataModel {
  final String id;
  final String counterName;
  final String contact;
  final String location;
  final String destination;
  final String imageUrl;
  final String webLink; // Add web link to the model

  BusCounterDataModel({
    required this.id,
    required this.counterName,
    required this.contact,
    required this.destination,
    required this.location,
    required this.imageUrl,
    required this.webLink, // Add web link to constructor
  });

  factory BusCounterDataModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BusCounterDataModel(
      id: doc.id,
      counterName: data['serviceName'] ?? '',
      contact: data['contact'] ?? '',
      location: data['location'] ?? '',
      destination: data['destination'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      webLink: data['webLink'] ?? '', // Get web link from Firestore
    );
  }
}

class AdminBusCounterServiceScreen extends StatefulWidget {
  @override
  _AdminBusCounterServiceScreenState createState() =>
      _AdminBusCounterServiceScreenState();
}

class _AdminBusCounterServiceScreenState
    extends State<AdminBusCounterServiceScreen> {
  final List<BusCounterDataModel> allBusCounter = [];
  List<BusCounterDataModel> filteredBusCounter = [];

  @override
  void initState() {
    super.initState();
    fetchBusCounter();
  }

  void fetchBusCounter() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('BusCounterList').get();
    final busCounter = querySnapshot.docs
        .map((doc) => BusCounterDataModel.fromFirestore(doc))
        .toList();
    setState(() {
      allBusCounter.addAll(busCounter);
      filteredBusCounter.addAll(busCounter);
    });
  }

  void filterBusCounter(String query) {
    setState(() {
      filteredBusCounter = allBusCounter
          .where((busCounter) => busCounter.counterName
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _deleteBusCounter(String id, int index) async {
    await FirebaseFirestore.instance
        .collection('BusCounterList')
        .doc(id)
        .delete();
    setState(() {
      filteredBusCounter.removeAt(index);
    });
  }

  void _editBusCounter(BusCounterDataModel ambulance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BusCounterForm(
          busCounter: ambulance,
          onSubmit: (updatedAmbulance) {
            setState(() {
              int index = filteredBusCounter
                  .indexWhere((a) => a.id == updatedAmbulance.id);
              if (index != -1) {
                filteredBusCounter[index] = updatedAmbulance;
                allBusCounter[allBusCounter.indexWhere(
                    (a) => a.id == updatedAmbulance.id)] = updatedAmbulance;
              }
            });
          },
        );
      },
    );
  }

  void _addBusCounter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BusCounterForm(
          onSubmit: (newAmbulance) {
            setState(() {
              filteredBusCounter.add(newAmbulance);
              allBusCounter.add(newAmbulance);
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
  void _openBookingUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Bus Counter'),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBusCounter,
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterBusCounter,
              decoration: InputDecoration(
                hintText: "Search Bus Counter...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBusCounter.length,
              itemBuilder: (context, index) {
                final busCounter = filteredBusCounter[index];

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
                              image: AssetImage('assets/icons/bus_counter.png'),
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
                                      busCounter.counterName,
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
                                        busCounter.location,
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
                            // Row with Image and Details
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image Section
                                  busCounter.imageUrl.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            busCounter.imageUrl,
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
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "ফোন: ${busCounter.contact}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "গন্তব্যস্থান: ${busCounter.destination}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Action Buttons
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.pColor.withOpacity(.1)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        _makeCall(busCounter.contact),
                                    icon: const Icon(Icons.call,
                                        color: Colors.white),
                                    label: const Text("Call"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        _openBookingUrl(busCounter.webLink),
                                    icon: const Icon(Icons.language,
                                        color: Colors.white),
                                    label: const Text("Online Book"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () =>
                                        _editBusCounter(busCounter),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _deleteBusCounter(busCounter.id, index),
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

class BusCounterForm extends StatefulWidget {
  final BusCounterDataModel? busCounter;
  final Function(BusCounterDataModel) onSubmit;

  BusCounterForm({this.busCounter, required this.onSubmit});

  @override
  _BusCounterFormState createState() => _BusCounterFormState();
}

class _BusCounterFormState extends State<BusCounterForm> {
  final _formKey = GlobalKey<FormState>();
  String? _serviceName, _contact, _location, _destination, _webLink, _imageUrl;

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
          .child('bus_counter_images')
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

        final busCounterData = {
          'serviceName': _serviceName!,
          'contact': _contact!,
          'location': _location!,
          'imageUrl': imageUrl ?? '',
          'destination': _destination!,
          'webLink': _webLink!,
        };

        if (widget.busCounter != null) {
          // Update existing ambulance
          await FirebaseFirestore.instance
              .collection('BusCounterList')
              .doc(widget.busCounter!.id)
              .update(busCounterData);
          widget.onSubmit(BusCounterDataModel(
            id: widget.busCounter!.id,
            counterName: _serviceName!,
            contact: _contact!,
            location: _location!,
            imageUrl: imageUrl ?? '',
            destination: _destination!,
            webLink: _webLink!,
          ));
        } else {
          // Add new ambulance
          final docRef = await FirebaseFirestore.instance
              .collection('BusCounterList')
              .add(busCounterData);
          widget.onSubmit(BusCounterDataModel(
            id: docRef.id,
            counterName: _serviceName!,
            contact: _contact!,
            location: _location!,
            imageUrl: imageUrl ?? '',
            destination: _destination!,
            webLink: _webLink!,
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
              if (_isLoading) const CircularProgressIndicator(),
              if (!_isLoading) ...[
                TextFormField(
                  initialValue: widget.busCounter?.counterName,
                  decoration: AppInputDecoration('Ambulance Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a Ambulance name' : null,
                  onSaved: (value) => _serviceName = value,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: widget.busCounter?.contact,
                  decoration: AppInputDecoration('Contact'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a contact number' : null,
                  onSaved: (value) => _contact = value,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: widget.busCounter?.destination,
                  decoration: AppInputDecoration('Destination'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter Destination' : null,
                  onSaved: (value) => _destination = value,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: widget.busCounter?.location,
                  decoration: AppInputDecoration('Location'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a location' : null,
                  onSaved: (value) => _location = value,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.busCounter?.webLink,
                  decoration: AppInputDecoration('Booking URL'),
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter the booking URL' : null,
                  onSaved: (value) => _webLink = value,
                ),
                const SizedBox(height: 8),
                _selectedImage != null
                    ? Image.file(
                        File(_selectedImage!.path),
                        height: 150,
                      )
                    : widget.busCounter?.imageUrl != null &&
                            widget.busCounter!.imageUrl.isNotEmpty
                        ? Image.network(
                            widget.busCounter!.imageUrl,
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
                      // Padding for the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: Text(widget.busCounter != null ? "Update" : "Add"),
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
