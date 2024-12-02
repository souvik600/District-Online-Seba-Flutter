import 'package:flutter/material.dart';
import '../../../../../AppColors/AppColors.dart';
import '../../../../../Styles/TextContainerStyle.dart';
import '../../../../../Widgets/information_category_list_widget.dart';
import 'AdminAmbulanceScreen/admin_ambulance_screen.dart';
import 'AdminAnimalDoctorScreen/admin_animal_doctor_screen.dart';
import 'AdminBloodDonnerListScreen/admin_blood_doner_screen.dart';
import 'AdminDoctorScreen/admin_doctor_screen.dart';
import 'AdminFireserviceScreen/admin_fire_service_screen.dart';
import 'AdminHospitalScreen/admin_hospital_screen.dart';
import 'AdminPoliceListScreen/admin_police_screen.dart';
import 'AdminPolliBiddutListScreen/admin_polli_biddut_screen.dart';

class AdminEmargencyServiceCategory extends StatelessWidget {
  const AdminEmargencyServiceCategory({super.key});

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
            TextContainerStyle("জরুরী সেবা সমূহ ...",AppColors.pColor),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: [
                AllInfromationCategoryList(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AdminHospitalScreen()
                      ));
                }, "assets/icons/hospital.png",
                    "হাসপাতাল"),
                AllInfromationCategoryList(
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminPoliceScreen(),
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
                          builder: (context) =>
                              AdminFireServiceScreen(),
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
                          builder: (context) =>
                              AdminAmbulanceServiceScreen(),
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
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: [
                AllInfromationCategoryList(
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminDoctorScreen(),
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
                          builder: (context) =>
                              AdminBloodDonorScreen(),
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
                          builder: (context) =>
                              AdminPolliBiddutScreen(),
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
                          builder: (context) =>
                              AdminAnimalDoctorScreen(),
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