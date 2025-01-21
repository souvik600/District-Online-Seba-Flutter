import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../AppColors/AppColors.dart';
import '../../../../../../Styles/TextContainerStyle.dart';
import '../../../../../../Utilitys/utilitys.dart';
import '../../../../AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminEmargencyServiceCategory/AdminPoliceListScreen/admin_police_screen.dart';

class UserPoliceScreen extends StatefulWidget {
  @override
  _UserPoliceScreenState createState() => _UserPoliceScreenState();
}

class _UserPoliceScreenState extends State<UserPoliceScreen> {
  final List<PoliceDataModels> allCategories = [];
  List<PoliceDataModels> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('PoliceList').get();
    final categories = querySnapshot.docs
        .map((doc) => PoliceDataModels.fromFirestore(doc))
        .toList();
    setState(() {
      allCategories.addAll(categories);
      filteredCategories.addAll(categories);
    });
  }

  void filterCategories(String query) {
    setState(() {
      filteredCategories = allCategories
          .where((category) =>
              category.location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("পুলিশ"),
      body: Stack(
        children: [
          ScreenBackground(context),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: filterCategories,
                  decoration: InputDecoration(
                    hintText: "তথ্য খুঁজুন...",
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    return PiliceListItem(
                      category: filteredCategories[index],
                      onMakeCall: () {
                        showCallDialog(
                            filteredCategories[index].contact, context);
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

class PiliceListItem extends StatelessWidget {
  final PoliceDataModels category;
  final VoidCallback onMakeCall;

  PiliceListItem({
    required this.category,
    required this.onMakeCall,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.4),
          border: Border.all(color: AppColors.pColor, width: 2),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/logos/PoliceLogo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.85),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: TextContainerStyle(
                              category.location, const Color(0xFF0E4399))),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Text(
                              category.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'kalpurush',
                              ),
                            ),
                            Text(
                              category.designation,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'kalpurush',
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  " মোবাইল: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    fontFamily: 'kalpurush',
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  category.contact,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    color: Colors.black,
                                    fontFamily: 'kalpurush',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  " ইমেইল : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    fontFamily: 'kalpurush',
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  category.email,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    color: Colors.blueGrey,
                                    fontFamily: 'kalpurush',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: ElevatedButton.icon(
                    onPressed: onMakeCall,
                    icon: const Icon(
                      Icons.call,
                      color: AppColors.pColor,
                    ),
                    label: const Text(
                      'ফোন করুন',
                      style: TextStyle(
                        color: AppColors.pColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'kalpurush',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
