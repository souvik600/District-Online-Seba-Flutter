import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Utilitys/utilitys.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../AppColors/AppColors.dart';
import '../../../../AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminCommonServiceCategory/AdminCarRentServiceScreen/admin_car_rent_service_screen.dart';

class UserCarRentServiceScreen extends StatefulWidget {
  @override
  _UserCarRentServiceScreenState createState() =>
      _UserCarRentServiceScreenState();
}

class _UserCarRentServiceScreenState extends State<UserCarRentServiceScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('গাড়ী ভাড়া'),
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
                                  child: Center(
                                    child: ElevatedButton.icon(
                                      onPressed: () =>
                                          showCallDialog(car.contact, context),
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
