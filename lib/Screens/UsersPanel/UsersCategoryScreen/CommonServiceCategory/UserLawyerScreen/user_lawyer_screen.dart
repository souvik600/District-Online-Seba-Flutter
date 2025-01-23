import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../AppColors/AppColors.dart';
import '../../../../../../Utilitys/utilitys.dart';
import '../../../../AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminCommonServiceCategory/AdminLawyerScreen/admin_lawyer_screen.dart';

class UserLawyerScreen extends StatefulWidget {
  @override
  _UserLawyerScreenState createState() => _UserLawyerScreenState();
}

class _UserLawyerScreenState extends State<UserLawyerScreen> {
  final List<LawyerDataModels> allLawyers = [];
  List<LawyerDataModels> filteredLawyers = [];

  @override
  void initState() {
    super.initState();
    fetchLawyers();
  }

  void fetchLawyers() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('LawyerList').get();
    final lawyers = querySnapshot.docs
        .map((doc) => LawyerDataModels.fromFirestore(doc))
        .toList();
    setState(() {
      allLawyers.addAll(lawyers);
      filteredLawyers.addAll(lawyers);
    });
  }

  void filterLawyers(String query) {
    setState(() {
      filteredLawyers = allLawyers
          .where((lawyer) =>
              lawyer.name.toLowerCase().contains(query.toLowerCase()) ||
              lawyer.specialization.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("আইনজীবী"),
      body: Stack(
        children: [
          ScreenBackground(context),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: filterLawyers,
                  decoration: InputDecoration(
                    hintText: "Search Lawyer...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredLawyers.length,
                  itemBuilder: (context, index) {
                    return LawyerListItem(
                      lawyer: filteredLawyers[index],
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

class LawyerListItem extends StatelessWidget {
  final LawyerDataModels lawyer;

  LawyerListItem({
    required this.lawyer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/icons/lawyer.png'),
                    fit: BoxFit.contain,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Card(
            elevation: 5,
            color: AppColors.wColor.withOpacity(.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.pColor, width: 1.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.pColor, width: 2.0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: lawyer.imageUrl.isNotEmpty
                                ? Image.network(
                                    lawyer.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/user.png',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: Colors.teal,
                          ),
                          icon: const Icon(Icons.call,
                              size: 16, color: Colors.white),
                          label: const Text(
                            "Call",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          onPressed: () =>
                              showCallDialog(lawyer.contact, context),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12.0),
                    // Details Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and Specialization
                          Row(
                            children: [
                              const Icon(Icons.person,
                                  size: 16, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  lawyer.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lawyer.specialization,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black45,
                            ),
                          ),
                          const Divider(),
                          // Contact Information
                          Row(
                            children: [
                              const Icon(Icons.phone,
                                  size: 16, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  lawyer.contact,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.email,
                                  size: 16, color: Colors.orange),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  lawyer.email,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  lawyer.location,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
