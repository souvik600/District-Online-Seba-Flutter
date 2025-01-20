import 'package:district_online_service/Screens/UsersPanel/UsersCategoryScreen/EmargencyServiceCategory/UserAnimalDoctorScreen/user_animal_doctor_screen.dart';
import 'package:district_online_service/Screens/UsersPanel/UsersCategoryScreen/EmargencyServiceCategory/UserBloodDonerListScreen/user_blood_doner_screen.dart';
import 'package:district_online_service/Screens/UsersPanel/UsersCategoryScreen/EmargencyServiceCategory/UserDoctorScreen/user_doctor_screen.dart';
import 'package:district_online_service/Screens/UsersPanel/UsersCategoryScreen/EmargencyServiceCategory/UserFireServiceScreen/user_fire_service_screen.dart';
import 'package:district_online_service/Screens/UsersPanel/UsersCategoryScreen/EmargencyServiceCategory/UserPoliceListScreen/user_police_list_screen.dart';
import 'package:district_online_service/Screens/UsersPanel/UsersCategoryScreen/EmargencyServiceCategory/UserPolliBiddutListScreen/user_polli_biddut_list_screen.dart';
import 'package:flutter/material.dart';
import '../../../../AppColors/AppColors.dart';
import '../../../../Styles/TextContainerStyle.dart';
import '../../../../Widgets/information_category_list_widget.dart';
import '../../../AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminEmargencyServiceCategory/AdminAnimalDoctorScreen/admin_animal_doctor_screen.dart';
import '../../../AdminPanel/AdminHomeScreen/AdminCategoryPage/AdminEmargencyServiceCategory/AdminPolliBiddutListScreen/admin_polli_biddut_screen.dart';
import 'UserHospitalScreen/user_hospital_screen.dart';
import 'userAmbulanceScreen/user_ambulance_screen.dart';

class EmargencyServiceCategory extends StatelessWidget {
  const EmargencyServiceCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.pColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            TextContainerStyle("জরুরী সেবা সমূহ ...", AppColors.pColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AllInfromationCategoryList(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserHospitalScreen()));
                }, "assets/icons/hospital.png", "হাসপাতাল"),
                AllInfromationCategoryList(
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserPoliceScreen(),
                        ));
                  },
                  "assets/icons/policeman.png",
                  "পুলিশ",
                ),
                AllInfromationCategoryList(
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserFireServiceScreen(),
                        ));
                  },
                  "assets/icons/fire-station.png",
                  "ফায়ার সার্ভিস",
                ),
                AllInfromationCategoryList(
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserAmbulanceServiceScreen(),
                        ));
                  },
                  "assets/icons/ambulance.png",
                  "অ্যাম্বুলেন্স",
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AllInfromationCategoryList(
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDoctorScreen(),
                        ));
                  },
                  "assets/icons/doctor.png",
                  "ডাক্তার",
                ),
                AllInfromationCategoryList(
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserBloodDonorScreen(),
                        ));
                  },
                  "assets/icons/donor.png",
                  "রক্তদান",
                ),
                AllInfromationCategoryList(
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserPolliBiddutScreen(),
                        ));
                  },
                  'assets/icons/electricity.png',
                  "পল্লী বিদ্যুৎ",
                ),
                AllInfromationCategoryList(
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserAnimalDoctorScreen(),
                        ));
                  },
                  'assets/icons/medical.png',
                  "পশু চিকিৎসক",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
