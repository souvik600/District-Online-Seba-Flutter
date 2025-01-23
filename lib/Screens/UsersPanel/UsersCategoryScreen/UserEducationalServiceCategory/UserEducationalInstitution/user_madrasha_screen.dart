import 'package:district_online_service/AppColors/AppColors.dart';
import 'package:district_online_service/Screens/AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminEducationalServiceCategory/AdminEducationalInstitution/school_details_screen.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../Styles/BackGroundStyle.dart';

class UserMadrashaScreen extends StatefulWidget {
  @override
  _UserMadrashaScreenState createState() => _UserMadrashaScreenState();
}

class _UserMadrashaScreenState extends State<UserMadrashaScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _openDetailsScreen(Map<String, dynamic> data) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SchoolDetailsScreen(data: data)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('মাদ্রাসা'),
      body: Stack(
        children: [
          ScreenBackground(context),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search Madrasha by Name ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _firestore
                      .collection('madrasha')
                      .where('name', isGreaterThanOrEqualTo: _searchQuery)
                      .where('name',
                          isLessThanOrEqualTo: _searchQuery + '\uf8ff')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final madrasha = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: madrasha.length,
                      itemBuilder: (context, index) {
                        final data = madrasha[index].data();
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              // Background Image
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/icons/mosque.png'),
                                        fit: BoxFit.contain,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                              // Card with transparent background
                              Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.white.withOpacity(0.85),
                                // Semi-transparent background
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.pColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: data['image'] != null
                                            ? Image.network(
                                                data['image'],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(Icons.local_hospital,
                                                size: 50),
                                        title: Text(
                                          data['name'],
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: AppColors.pColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.red,
                                            ),
                                            Text(data['location']),
                                          ],
                                        ),
                                        onTap: () => _openDetailsScreen(data),
                                        trailing: const Icon(
                                            Icons.arrow_forward_ios_sharp),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
