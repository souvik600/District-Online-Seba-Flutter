import 'package:district_online_service/Screens/AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminWorkerServiceCategory/AdminElectricianServiceScreen/admin_electrition_service_screen.dart';
import 'package:district_online_service/Screens/AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminWorkerServiceCategory/AdminPlumberServiceScreen/admin_plumber_service_screen.dart';
import 'package:flutter/material.dart';
import '../../../../../AppColors/AppColors.dart';
import '../../../../../Styles/TextContainerStyle.dart';
import '../../../../../Widgets/information_category_list_widget.dart';
import '../../../../SplashScreen.dart';



class AdminWorkerServiceCategory extends StatelessWidget {
  const AdminWorkerServiceCategory({super.key});

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
            TextContainerStyle("মিস্ত্রি/শ্র‌মিক...",AppColors.pColor),
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
                              AdminElectricianServiceScreen(),
                        ));
                  },
                  'assets/icons/electrician(1).png',
                  'ইলেকট্রিশিয়ান',
                ),
                AllInfromationCategoryList(
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminPlumberServiceScreen(),
                        ));
                  },
                  'assets/icons/plumber.png',
                  "প্লাম্বার",
                ),
                AllInfromationCategoryList(
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SplashScreen(),
                        ));
                  },
                  'assets/icons/bricklayer.png',
                  "রাজ মিস্ত্রি",
                ),
                AllInfromationCategoryList(
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SplashScreen(),
                        ));
                  },
                  'assets/icons/chisel.png',
                  "কাঠমিস্ত্রি",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
