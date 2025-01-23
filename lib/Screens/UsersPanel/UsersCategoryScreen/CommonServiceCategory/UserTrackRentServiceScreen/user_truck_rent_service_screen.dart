import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Utilitys/utilitys.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../AppColors/AppColors.dart';
import '../../../../AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminCommonServiceCategory/AdminTruckRentServiceScreen/admin_truck_rent_service_screen.dart';

class UserTruckRentServiceScreen extends StatefulWidget {
  @override
  _UserTruckRentServiceScreenState createState() =>
      _UserTruckRentServiceScreenState();
}

class _UserTruckRentServiceScreenState
    extends State<UserTruckRentServiceScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('ট্র্যাক পরিবহন'),
      body: Stack(
        children: [
          ScreenBackground(context),
          Column(
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
                                  image:
                                  AssetImage('assets/icons/shipment.png'),
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
                                          truck.serviceName,
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                              style:
                                              const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              "Phone: ${truck.contact}",
                                              style:
                                              const TextStyle(fontSize: 15),
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
                                  child: Center(
                                    child: ElevatedButton.icon(
                                      onPressed: () => showCallDialog(
                                          truck.contact, context),
                                      icon: const Icon(Icons.call,
                                          color: Colors.white),
                                      label: const Text("Call Now!"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                      ),
                                    ),
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

