import 'dart:io';
import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Styles/InputDecorationStyle.dart';
import 'package:district_online_service/Utilitys/utilitys.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../AppColors/AppColors.dart';

class CarRentDataModel {
  final String id;
  final String serviceName;
  final String contact;
  final bool isAvailable;
  final String location;
  final String imageUrl;
  final String carType;
  final String driverName;

  CarRentDataModel({
    required this.id,
    required this.serviceName,
    required this.contact,
    required this.isAvailable,
    required this.location,
    required this.imageUrl,
    required this.carType,
    required this.driverName,
  });

  factory CarRentDataModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CarRentDataModel(
      id: doc.id,
      serviceName: data['serviceName'] ?? '',
      contact: data['contact'] ?? '',
      isAvailable: data['isAvailable'] ?? false,
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      carType: data['carType'] ?? '',
      driverName: data['driverName'] ?? '',
    );
  }
}

class AdminCarRentServiceScreen extends StatefulWidget {
  @override
  _AdminCarRentServiceScreenState createState() =>
      _AdminCarRentServiceScreenState();
}

class _AdminCarRentServiceScreenState extends State<AdminCarRentServiceScreen> {
  final List<CarRentDataModel> allCarRents = [];
  List<CarRentDataModel> filteredCarRents = [];

  @override
  void initState() {
    super.initState();
    fetchCarRents();
  }

  void fetchCarRents() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('CarRentList').get();
    final carRents = querySnapshot.docs
        .map((doc) => CarRentDataModel.fromFirestore(doc))
        .toList();
    setState(() {
      allCarRents.addAll(carRents);
      filteredCarRents.addAll(carRents);
    });
  }

  void filterCarRents(String query) {
    setState(() {
      filteredCarRents = allCarRents
          .where((car) =>
              car.serviceName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _deleteCarRent(String id, int index) async {
    await FirebaseFirestore.instance.collection('CarRentList').doc(id).delete();
    setState(() {
      filteredCarRents.removeAt(index);
    });
  }

  void _editCarRent(CarRentDataModel car) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CarRentForm(
          carRent: car,
          onSubmit: (updatedCar) {
            setState(() {
              int index =
                  filteredCarRents.indexWhere((c) => c.id == updatedCar.id);
              if (index != -1) {
                filteredCarRents[index] = updatedCar;
                allCarRents[allCarRents
                    .indexWhere((c) => c.id == updatedCar.id)] = updatedCar;
              }
            });
          },
        );
      },
    );
  }

  void _addCarRent() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CarRentForm(
          onSubmit: (newCar) {
            setState(() {
              filteredCarRents.add(newCar);
              allCarRents.add(newCar);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('গাড়ী ভাড়া'),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCarRent,
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          ScreenBackground(context),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: filterCarRents,
                  decoration: InputDecoration(
                    hintText: "Search Car Rent Services...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCarRents.length,
                  itemBuilder: (context, index) {
                    final car = filteredCarRents[index];

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
                                  image:
                                      AssetImage('assets/icons/rent-a-car.png'),
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
                              border: Border.all(
                                  color: AppColors.pColor, width: 1.5),
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
                                          car.serviceName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            color: AppColors.pColor,
                                          ),
                                          Text(
                                            car.location,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      car.imageUrl.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                car.imageUrl,
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
                                                  Icons.local_shipping,
                                                  size: 40),
                                            ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Driver: ${car.driverName}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              "Type: ${car.carType}",
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              "Phone: ${car.contact}",
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              car.isAvailable
                                                  ? "Available"
                                                  : "Not Available",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: car.isAvailable
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
                                        onPressed: () => showCallDialog(
                                            car.contact, context),
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
                                        onPressed: () => _editCarRent(car),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            _deleteCarRent(car.id, index),
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
        ],
      ),
    );
  }
}

class CarRentForm extends StatefulWidget {
  final CarRentDataModel? carRent;
  final Function(CarRentDataModel) onSubmit;

  CarRentForm({this.carRent, required this.onSubmit});

  @override
  _CarRentFormState createState() => _CarRentFormState();
}

class _CarRentFormState extends State<CarRentForm> {
  final _formKey = GlobalKey<FormState>();
  String? _serviceName, _contact, _location, _imageUrl, _carType, _driverName;
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
          .child('car_rent_images')
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

        final carRentData = {
          'serviceName': _serviceName!,
          'contact': _contact!,
          'isAvailable': _isAvailable,
          'location': _location!,
          'imageUrl': imageUrl ?? '',
          'carType': _carType!,
          'driverName': _driverName!,
        };

        if (widget.carRent != null) {
          // Update existing car rent
          await FirebaseFirestore.instance
              .collection('CarRentList')
              .doc(widget.carRent!.id)
              .update(carRentData);
          widget.onSubmit(CarRentDataModel(
            id: widget.carRent!.id,
            serviceName: _serviceName!,
            contact: _contact!,
            isAvailable: _isAvailable,
            location: _location!,
            imageUrl: imageUrl ?? '',
            carType: _carType!,
            driverName: _driverName!,
          ));
        } else {
          // Add new car rent
          final docRef = await FirebaseFirestore.instance
              .collection('CarRentList')
              .add(carRentData);
          widget.onSubmit(CarRentDataModel(
            id: docRef.id,
            serviceName: _serviceName!,
            contact: _contact!,
            isAvailable: _isAvailable,
            location: _location!,
            imageUrl: imageUrl ?? '',
            carType: _carType!,
            driverName: _driverName!,
          ));
        }
        Navigator.of(context).pop();
      } catch (e) {
        print("Error saving car rent: $e");
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
                  initialValue: widget.carRent?.serviceName,
                  decoration: AppInputDecoration('Car Rent Service Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a service name' : null,
                  onSaved: (value) => _serviceName = value,
                ),
                SizedBox(height: 10,),
                TextFormField(
                  initialValue: widget.carRent?.contact,
                  decoration: AppInputDecoration('Contact'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a contact number' : null,
                  onSaved: (value) => _contact = value,
                ),
                SizedBox(height: 10,),
                TextFormField(
                  initialValue: widget.carRent?.location,
                  decoration: AppInputDecoration('Location'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a location' : null,
                  onSaved: (value) => _location = value,
                ),
                SizedBox(height: 10,),
                TextFormField(
                  initialValue: widget.carRent?.carType,
                  decoration: AppInputDecoration('Car Type'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter car type' : null,
                  onSaved: (value) => _carType = value,
                ),
                SizedBox(height: 10,),
                TextFormField(
                  initialValue: widget.carRent?.driverName,
                  decoration: AppInputDecoration('Driver Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter driver name' : null,
                  onSaved: (value) => _driverName = value,
                ),
                SizedBox(height: 10,),
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
                    : widget.carRent?.imageUrl != null &&
                            widget.carRent!.imageUrl.isNotEmpty
                        ? Image.network(
                            widget.carRent!.imageUrl,
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
                    child: Text(widget.carRent != null ? "Update" : "Add"),
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
