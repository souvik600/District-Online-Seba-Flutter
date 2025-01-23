import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Utilitys/utilitys.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../AppColors/AppColors.dart';
import '../../../../AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminCommonServiceCategory/AdminCurierServiceScreen/admin_curier_service_screen.dart';

class UserCourierServiceScreen extends StatefulWidget {
  @override
  _UserCourierServiceScreenState createState() =>
      _UserCourierServiceScreenState();
}

class _UserCourierServiceScreenState extends State<UserCourierServiceScreen> {
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

  void _openBookingUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('কুরিয়ার'),
      body: Stack(
        children: [
          ScreenBackground(context),
          Column(
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
                                  image: AssetImage(
                                      'assets/icons/cargo-truck.png'),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              style:
                                                  const TextStyle(fontSize: 16),
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
                                        onPressed: () => showCallDialog(
                                            courierService.contact, context),
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
                                        onPressed: () => _openBookingUrl(
                                            courierService.webLink),
                                        icon: const Icon(Icons.language,
                                            color: Colors.white),
                                        label: const Text("Online Book"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
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
        ],
      ),
    );
  }
}
