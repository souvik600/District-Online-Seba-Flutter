import 'package:district_online_service/Screens/AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminEducationalInstitution/admin_collage_screen.dart';
import 'package:district_online_service/Screens/AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminEducationalInstitution/admin_madrasha_screen.dart';
import 'package:flutter/material.dart';

import '../../../../AppColors/AppColors.dart';
import '../../../../Styles/TextContainerStyle.dart';
import '../../../../Widgets/information_category_list_widget.dart';
import '../../../AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminEducationalInstitution/admin_high_school_screen.dart';
import '../../../AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminEducationalInstitution/admin_primary_school_screen.dart';
import '../../../SplashScreen.dart';

class EducationalServiceCategory extends StatelessWidget {
  const EducationalServiceCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border:
        Border.all(color: AppColors.pColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            TextContainerStyle("শিক্ষা প্রতিষ্ঠান...",AppColors.pColor),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: [
                AllInfromationCategoryList(
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminPrimarySchoolScreen(),
                        ));
                  },
                  'assets/icons/primary-school.png',
                  'প্রাইমারী-স্কুল',
                ),
                AllInfromationCategoryList(
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminHighSchoolScreen(),
                        ));
                  },
                  'assets/icons/school.png',
                  "উচ্চ বিদ্যালয়",
                ),
                AllInfromationCategoryList(
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminCollegeScreen(),
                        ));
                  },
                  'assets/icons/college.png',
                  "কলেজ",
                ),
                AllInfromationCategoryList(
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminMadrashaScreen(),
                        ));
                  },
                  'assets/icons/mosque.png',
                  "মাদ্রাসা",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
