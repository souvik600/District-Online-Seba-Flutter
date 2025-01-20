import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../AppColors/AppColors.dart';
import '../../../../../../Styles/TextContainerStyle.dart';
import '../../../../../../Utilitys/utilitys.dart';
import '../../../../AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminEmargencyServiceCategory/AdminPolliBiddutListScreen/admin_polli_biddut_screen.dart';

class UserPolliBiddutScreen extends StatefulWidget {
  @override
  _UserPolliBiddutScreenState createState() => _UserPolliBiddutScreenState();
}

class _UserPolliBiddutScreenState extends State<UserPolliBiddutScreen> {
  final List<PolliBiddutModels> allCategories = [];
  List<PolliBiddutModels> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('PolliBiddut').get();
    final categories = querySnapshot.docs
        .map((doc) => PolliBiddutModels.fromFirestore(doc))
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
              category.headingName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('পল্লী বিদ্যুৎ'),
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
                    return PolliBiddutListItem(
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

class PolliBiddutListItem extends StatelessWidget {
  final PolliBiddutModels category;
  final VoidCallback onMakeCall;

  PolliBiddutListItem({
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
                        'assets/logos/pollibiddutLogo.png',
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
                              category.headingName, Colors.deepPurple)),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "ধরন : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
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
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  " অবস্থান: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    fontFamily: 'kalpurush',
                                    color: Colors.black,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    category.location,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: 'kalpurush',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  " মোবাইল: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
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
                                    fontWeight: FontWeight.w400,
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
            OverflowBar(
              alignment: MainAxisAlignment.spaceBetween,
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
