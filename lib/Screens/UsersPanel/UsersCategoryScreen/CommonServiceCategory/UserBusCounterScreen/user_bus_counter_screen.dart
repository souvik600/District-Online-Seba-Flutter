import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Utilitys/utilitys.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../AppColors/AppColors.dart';
import '../../../../AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminCommonServiceCategory/AdminBusCounterScreen/admin_bus_counter_screen.dart';


class UserBusCounterServiceScreen extends StatefulWidget {
  @override
  _UserBusCounterServiceScreenState createState() =>
      _UserBusCounterServiceScreenState();
}

class _UserBusCounterServiceScreenState
    extends State<UserBusCounterServiceScreen> {
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


  void _openBookingUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("বাস কাউন্টার"),
      body: Stack(
        children: [
          ScreenBackground(context),
          Column(
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
                                  image: AssetImage(
                                      'assets/icons/bus_counter.png'),
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
                                          busCounter.counterName,
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                              style:
                                              const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              "গন্তব্যস্থান: ${busCounter.destination}",
                                              style:
                                              const TextStyle(fontSize: 15),
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
                                            busCounter.contact, context),
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

