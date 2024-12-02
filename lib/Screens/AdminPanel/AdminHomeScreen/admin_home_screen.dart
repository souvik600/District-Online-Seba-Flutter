import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../AppColors/AppColors.dart';
import '../../../Styles/BackGroundStyle.dart';
import '../../../Utilitys/utilitys.dart';
import '../../../Widgets/AdminImageSlideShowWidget.dart';
import '../../../Widgets/AdminNoticeTextWidget.dart';
import '../../UsersPanel/UsersCategoryScreen/WorkerServiceCategory/worker_service_category.dart';
import '../../UsersPanel/UsersProfileScreen/user_profile_screen.dart';
import 'AdminCategoryPage/AdminCommonServiceCategory/admin_common_service_category.dart';
import 'AdminCategoryPage/AdminEducationalServiceCategory/admin_educational_institution_catagory_screen.dart';
import 'AdminCategoryPage/AdminEmargencyServiceCategory/admin_emargency_service_category.dart';

class AdminHomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String profileImageUrl = '';

    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.pColor,
          title: const Text(
            "Admin",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              fontFamily: 'kalpurush',
              color: colorWhite,
            ),
          ),
          actions: [
            // Profile Image Button
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: FutureBuilder(
                future: loadProfileImage(),
                builder: (context, snapshot) {
                  // Show loading indicator while fetching the image
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : const AssetImage('assets/images/user.png')
                              as ImageProvider,
                    ),
                  );
                },
              ),
            ),
          ],
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          toolbarHeight: 70,
        ),
        body: Stack(
          children: [
            ScreenBackground(context),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.pColor.withOpacity(0.8),
                                  AppColors.pColor,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: AdminImageSlideShow(),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15, bottom: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 55,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.pColor.withOpacity(.4),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.wColor,
                                  blurRadius: 6,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: AdminMovingNoticeText(),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          AdminEmargencyServiceCategory(),
                          SizedBox(height: 16),
                          AdminCommonServiceCategory(),
                          SizedBox(height: 16),
                          AdminEducationalServiceCategory(),
                          SizedBox(height: 16),
                          WorkerServiceCategory(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
