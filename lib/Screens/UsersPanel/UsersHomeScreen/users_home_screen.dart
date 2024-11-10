import 'package:district_online_service/Screens/AdminPanel/AdminHomeScreen/admin_home_screen.dart';
import 'package:district_online_service/Screens/SplashScreen.dart';
import 'package:district_online_service/Screens/UsersPanel/UsersProfileScreen/user_profile_screen.dart';
import 'package:district_online_service/Styles/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../AppColors/AppColors.dart';
import '../../../Styles/BackGroundStyle.dart';
import '../../../Utilitys/utilitys.dart';
import '../../../Widgets/CustomDrawerWidget.dart';
import '../../../Widgets/emergency_service_list_widget.dart';
import '../../../Widgets/information_category_list_widget.dart';
import '../../NavigationBerScreen.dart';

class UsersHomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.pColor,
          title: AppName(),
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              size: 30,
              color: AppColors.wColor,
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          actions: [
            FutureBuilder<String>(
              future: loadProfileImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminHomeScreen(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: snapshot.hasData && snapshot.data!.isNotEmpty
                        ? NetworkImage(snapshot.data!)
                        : const AssetImage('assets/images/default_profile.png')
                    as ImageProvider,
                  ),
                );
              },
            ),
            SizedBox(width: 10,)
          ],
          elevation: 0,
          // Remove elevation for a flat AppBar
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom:
              Radius.circular(20), // Adjust the radius for circular edges
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              ScreenBackground(context),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 205,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.pColor.withOpacity(0.8),
                                    AppColors.pColor,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(20)
                                  // bottomLeft: Radius.circular(20),
                                  // bottomRight: Radius.circular(20),
                                ),
                              ),
                              //child: ImageSlideShow(),
                            ),

                            Container(
                              margin:
                              const EdgeInsets.only(top: 15, bottom: 20),
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.pColor.withOpacity(.4),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.sdColor,
                                    blurRadius: 6,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                //child: Center(child: MovingNoticeText()),
                              ),

                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "ক্যাটাগরি সমূহ ...",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.pColor,
                                fontFamily: 'kalpurush'),
                          ),
                          const SizedBox(
                            width: 70,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NavigationBerScreen(selectedIndex: 1),
                                ),
                              );
                            },
                            child: const Text(
                              "সমস্ত দেখুন...",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'kalpurush',
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        // dental
                        child: Container(
                          height: 120,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              AllInfromationCategoryList(
                                    () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SplashScreen()
                                      ));
                                },
                                'assets/icons/history-book.png',
                                'জেলার ইতিহাস',
                              ),
                              const SizedBox(
                                width: 15,
                              ),

                              //For Heart
                              AllInfromationCategoryList(
                                    () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SplashScreen(),
                                      ));
                                },
                                'assets/icons/map.png',
                                "মানচিত্র",
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              AllInfromationCategoryList(
                                    () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SplashScreen(),
                                      ));
                                },
                                'assets/icons/newspaper.png',
                                "সংবাদপত্র",
                              ),
                              const SizedBox(
                                width: 15,
                              ),

                              //Brain
                              AllInfromationCategoryList(
                                    () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SplashScreen(),
                                      ));
                                },
                                'assets/icons/history-place.png',
                                "দর্শনীয় স্থান",
                              ),
                              const SizedBox(
                                width: 15,
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
                                'assets/icons/electricity.png',
                                "পল্লী বিদ্যুৎ",
                              ),
                              const SizedBox(
                                width: 15,
                              ),

                              AllInfromationCategoryList(
                                    () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SplashScreen(),
                                      ));
                                },
                                'assets/icons/medical.png',
                                "পশু চিকিৎসক",
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              AllInfromationCategoryList(
                                    () {
                                  launch('https://www.narail.gov.bd/');
                                },
                                'assets/e-seba-icon/select-all.png',
                                'ই-সেবা..',
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              AllInfromationCategoryList(
                                    () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NavigationBerScreen(selectedIndex: 1),
                                    ),
                                  );
                                },
                                'assets/e-seba-icon/add.png',
                                "More..",
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        "জরুরী সেবা সমূহ ...",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.pColor,
                            fontFamily: 'kalpurush'),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                EmergencyServiceList(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SplashScreen(),
                                    ),
                                  );
                                }, "assets/images/haspital.jpg", "হাসপাতাল"),
                                const SizedBox(width: 10),
                                EmergencyServiceList(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SplashScreen(),
                                    ),
                                  );
                                }, "assets/images/police.jpg", "পুলিশ"),
                                const SizedBox(width: 10),
                                EmergencyServiceList(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SplashScreen(),
                                    ),
                                  );
                                }, "assets/images/fireservice.png",
                                    "ফায়ার সার্ভিস"),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                EmergencyServiceList(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SplashScreen(),
                                    ),
                                  );
                                }, "assets/images/ambulance.jpg",
                                    "অ্যাম্বুলেন্স"),
                                const SizedBox(width: 10),
                                EmergencyServiceList(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SplashScreen(),
                                    ),
                                  );
                                }, "assets/images/doctor1.jpg", "ডাক্তার"),
                                const SizedBox(width: 10),
                                EmergencyServiceList(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SplashScreen(),
                                    ),
                                  );
                                }, "assets/images/bloodDoner.jpg", "রক্তদান"),
                              ],
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: const Drawer(
          child: CustomDrawerWidget(),
        ),
      ),
    );
  }
}
