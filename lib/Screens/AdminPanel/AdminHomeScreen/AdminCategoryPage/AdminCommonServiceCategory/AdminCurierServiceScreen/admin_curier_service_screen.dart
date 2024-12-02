import 'package:district_online_service/Styles/InputDecorationStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../AppColors/AppColors.dart';

class CourierServiceDataModel {
  final String id;
  final String serviceName;
  final String contact;
  final String location;
  final String webLink;

  CourierServiceDataModel({
    required this.id,
    required this.serviceName,
    required this.contact,
    required this.location,
    required this.webLink,
  });

  factory CourierServiceDataModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourierServiceDataModel(
      id: doc.id,
      serviceName: data['serviceName'] ?? '',
      contact: data['contact'] ?? '',
      location: data['location'] ?? '',
      webLink: data['webLink'] ?? '',
    );
  }
}

class AdminCourierServiceScreen extends StatefulWidget {
  @override
  _AdminCourierServiceScreenState createState() =>
      _AdminCourierServiceScreenState();
}

class _AdminCourierServiceScreenState extends State<AdminCourierServiceScreen> {
  final List<CourierServiceDataModel> allCourierServices = [];
  List<CourierServiceDataModel> filteredCourierServices = [];

  @override
  void initState() {
    super.initState();
    fetchCourierServices();
  }

  void fetchCourierServices() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('CourierServiceList').get();
    final services = querySnapshot.docs
        .map((doc) => CourierServiceDataModel.fromFirestore(doc))
        .toList();
    setState(() {
      allCourierServices.addAll(services);
      filteredCourierServices.addAll(services);
    });
  }

  void filterCourierServices(String query) {
    setState(() {
      filteredCourierServices = allCourierServices
          .where((service) =>
              service.serviceName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _deleteCourierService(String id, int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('CourierServiceList')
          .doc(id)
          .delete();
      setState(() {
        filteredCourierServices.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Courier service deleted successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete courier service."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmDelete(String id, int index) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Courier Service"),
          content: Text("Are you sure you want to delete this service?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _deleteCourierService(id, index);
    }
  }

  void _editCourierService(CourierServiceDataModel service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CourierServiceForm(
          courierService: service,
          onSubmit: (updatedService) {
            setState(() {
              int index = filteredCourierServices
                  .indexWhere((s) => s.id == updatedService.id);
              if (index != -1) {
                filteredCourierServices[index] = updatedService;
                allCourierServices[allCourierServices.indexWhere(
                    (s) => s.id == updatedService.id)] = updatedService;
              }
            });
          },
        );
      },
    );
  }

  void _addCourierService() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CourierServiceForm(
          onSubmit: (newService) {
            setState(() {
              filteredCourierServices.add(newService);
              allCourierServices.add(newService);
            });
          },
        );
      },
    );
  }

  Future<void> _makeCall(String contact) async {
    final Uri launchUri = Uri(scheme: 'tel', path: contact);
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
      appBar: CustomAppBar('Courier Service'),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCourierService,
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterCourierServices,
              decoration: InputDecoration(
                hintText: "Search Courier Service...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCourierServices.length,
              itemBuilder: (context, index) {
                final courierService = filteredCourierServices[index];
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/icons/cargo-truck.png'),
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
                                      courierService.serviceName,
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
                                        courierService.location,
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
                                          "ফোন: ${courierService.contact}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 2,
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
                                        _makeCall(courierService.contact),
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
                                        _openBookingUrl(courierService.webLink),
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
                                        _editCourierService(courierService),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _confirmDelete(
                                        courierService.id, index),
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

class CourierServiceForm extends StatefulWidget {
  final CourierServiceDataModel? courierService;
  final Function(CourierServiceDataModel) onSubmit;

  CourierServiceForm({this.courierService, required this.onSubmit});

  @override
  _CourierServiceFormState createState() => _CourierServiceFormState();
}

class _CourierServiceFormState extends State<CourierServiceForm> {
  final _formKey = GlobalKey<FormState>();
  String? _serviceName, _contact, _location, _webLink;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final serviceData = CourierServiceDataModel(
        id: widget.courierService?.id ??
            FirebaseFirestore.instance
                .collection('CourierServiceList')
                .doc()
                .id,
        // Generate a new ID if adding
        serviceName: _serviceName!,
        contact: _contact!,
        location: _location!,
        webLink: _webLink!,
      );

      try {
        if (widget.courierService != null) {
          // Update existing document
          await FirebaseFirestore.instance
              .collection('CourierServiceList')
              .doc(serviceData.id)
              .update({
            'serviceName': serviceData.serviceName,
            'contact': serviceData.contact,
            'location': serviceData.location,
            'webLink': serviceData.webLink,
          });
        } else {
          // Add new document
          await FirebaseFirestore.instance
              .collection('CourierServiceList')
              .doc(serviceData.id)
              .set({
            'serviceName': serviceData.serviceName,
            'contact': serviceData.contact,
            'location': serviceData.location,
            'webLink': serviceData.webLink,
          });
        }

        widget.onSubmit(serviceData);
        Navigator.of(context).pop();

        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: Text(widget.courierService != null
                  ? "Courier service updated successfully!"
                  : "Courier service added successfully!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Show error dialog if Firebase operation fails
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("Failed to save data: $e"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: widget.courierService?.serviceName,
                decoration: AppInputDecoration('Courier Service Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter service name' : null,
                onSaved: (value) => _serviceName = value,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                initialValue: widget.courierService?.contact,
                decoration: AppInputDecoration('Contact Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter contact number' : null,
                onSaved: (value) => _contact = value,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                initialValue: widget.courierService?.location,
                decoration: AppInputDecoration('Location'),
                validator: (value) => value!.isEmpty ? 'Enter location' : null,
                onSaved: (value) => _location = value,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                initialValue: widget.courierService?.webLink,
                decoration: AppInputDecoration('Booking URL'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter booking URL' : null,
                onSaved: (value) => _webLink = value,
              ),
              const SizedBox(height: 16),
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
                  child: Text(widget.courierService != null ? "Update" : "Add"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
