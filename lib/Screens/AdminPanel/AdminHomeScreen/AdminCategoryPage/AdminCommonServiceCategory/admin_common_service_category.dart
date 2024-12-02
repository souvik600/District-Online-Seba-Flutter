import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../AppColors/AppColors.dart';
import '../../../../../Styles/TextContainerStyle.dart';
import '../../../../../Widgets/information_category_list_widget.dart';
import '../../../../SplashScreen.dart';
import '../../../../UsersPanel/UsersCategoryScreen/CommonServiceCategory/DistrictHistoryScreen/district_history_screen.dart';
import '../../../../UsersPanel/UsersCategoryScreen/CommonServiceCategory/DistrictMapScreen/district_map_screen.dart';
import '../../../../UsersPanel/UsersCategoryScreen/CommonServiceCategory/NewsPaperScreen/news_paper_screen.dart';

import 'AdminBusCounterScreen/admin_bus_counter_screen.dart';
import 'AdminCurierServiceScreen/admin_curier_service_screen.dart';



class AdminCommonServiceCategory extends StatelessWidget {
  const AdminCommonServiceCategory({super.key});

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
            TextContainerStyle("অন্যান্য সেবা সমূহ ...",AppColors.pColor),
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
                              DistrictHistoryScreen(),
                        ));
                  },
                  'assets/icons/history-book.png',
                  'জেলার ইতিহাস',
                ),
                AllInfromationCategoryList(
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MapScreen(),
                        ));
                  },
                  'assets/icons/map.png',
                  "মানচিত্র",
                ),
                AllInfromationCategoryList(
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewspaperScreen(),
                        ));
                  },
                  'assets/icons/newspaper.png',
                  "সংবাদপত্র",
                ),
                AllInfromationCategoryList(
                      () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           HistricalPlaceScreen(),
                    //     ));
                  },
                  'assets/icons/history-place.png',
                  "দর্শনীয় স্থান",
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: [
                AllInfromationCategoryList(
                      () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           ParkResortScreen(),
                    //     ));
                  },
                  'assets/icons/bungalow.png',
                  'পার্ক রিসোর্ট',
                ),
                AllInfromationCategoryList(
                      () {
                    launch(
                        'https://bangladesh-railway.com/');
                  },
                  'assets/icons/rail.png',
                  "ট্রেন টিকিট",
                ),
                AllInfromationCategoryList(
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminBusCounterServiceScreen(),
                        ));
                  },
                  'assets/icons/bus_counter.png',
                  "বাস কাউন্টার",
                ),
                AllInfromationCategoryList(
                      () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           SplashScreen(),
                    //     ));
                  },
                  'assets/icons/bank.png',
                  "ব্যাংক",
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
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
                              AdminCourierServiceScreen(),
                        ));
                  },
                  'assets/icons/cargo-truck.png',
                  "কুরিয়ার",
                ),
                AllInfromationCategoryList(
                      () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           SplashScreen(),
                    //     ));
                  },
                  'assets/icons/rent-a-car.png',
                  "গাড়ী ভাড়া",
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
                  'assets/icons/shipment.png',
                  'ট্র্যাক পরিবহন',
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
                  'assets/icons/hotel.png',
                  "হোটেল",
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
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
                              SplashScreen(),
                        ));
                  },
                  'assets/icons/burger.png',
                  "রেঁস্তোরা",
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
                  'assets/icons/lawyer.png',
                  "আইনজীবী",
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
                  'assets/icons/commentator.png',
                  'সংবাদিক',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
