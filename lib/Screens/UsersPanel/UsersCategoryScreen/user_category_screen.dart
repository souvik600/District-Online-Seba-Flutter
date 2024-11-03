import 'package:district_online_service/Screens/UsersPanel/UsersCategoryScreen/EducationalServiceCategory/educational_service_category.dart';
import 'package:district_online_service/Screens/UsersPanel/UsersCategoryScreen/EmargencyServiceCategory/emargency_service_category.dart';
import 'package:district_online_service/Screens/UsersPanel/UsersCategoryScreen/GovtE_ServiceCategory/govt_e_Service_category.dart';
import 'package:district_online_service/Screens/UsersPanel/UsersCategoryScreen/WorkerServiceCategory/worker_service_category.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';

import '../../../AppColors/AppColors.dart';
import '../../../Styles/BackGroundStyle.dart';

class UserCategoryScreen extends StatefulWidget {
  const UserCategoryScreen({super.key});

  @override
  State<UserCategoryScreen> createState() => _UserCategoryScreenState();
}
class _UserCategoryScreenState extends State<UserCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('ক্যাটাগরি সমূহ ...'),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ScreenBackground(context),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: const SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SizedBox(height: 8),
                          EmargencyServiceCategory(),
                          SizedBox(height: 16),
                         // OtherServiceList(),
                          SizedBox(height: 16),
                          GovtE_ServiceCategory(),
                          SizedBox(height: 16),
                          EducationalServiceCategory(),
                          SizedBox(height: 16),
                          WorkerServiceCategory(),
                          SizedBox(
                            height: 180,
                          ),
                        ],
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
