import 'package:district_online_service/Utilitys/utilitys.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../AppColors/AppColors.dart';
import '../../../../AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminEmargencyServiceCategory/AdminAmbulanceScreen/admin_ambulance_screen.dart';

class UserAmbulanceServiceScreen extends StatefulWidget {
  @override
  _UserAmbulanceServiceScreenState createState() =>
      _UserAmbulanceServiceScreenState();
}

class _UserAmbulanceServiceScreenState
    extends State<UserAmbulanceServiceScreen> {
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('অ্যাম্বুলেন্স'),
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
                                      const Icon(
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
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "Type: ${ambulance.ambulanceType}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "Phone: ${ambulance.contact}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        const SizedBox(
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
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.pColor.withOpacity(.1)),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        showCallDialog(ambulance.contact, context),
                                    icon: const Icon(Icons.call,
                                        color: Colors.white),
                                    label: const Text("Call Now"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                    ),
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

