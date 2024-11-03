import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../AppColors/AppColors.dart';
import '../../../../Styles/TextContainerStyle.dart';
import '../../../../Widgets/information_category_list_widget.dart';

class GovtE_ServiceCategory extends StatelessWidget {
  const GovtE_ServiceCategory({super.key});

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
            TextContainerStyle("নড়াইল ই-সেবা ...",AppColors.pColor),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: [
                AllInfromationCategoryList(
                      () {
                    launch(
                        'http://www.narail.gov.bd/bn/site/view/officer_list');
                  },
                  'assets/e-seba-icon/administrator.png',
                  "প্রশাসন কর্মকর্তা",
                ),
                AllInfromationCategoryList(
                      () {
                    launch(
                        'https://bangladesh.gov.bd/site/view/eservices/%E0%A6%AE%E0%A7%8E%E0%A6%B8%E0%A7%8D%E0%A6%AF%20%E0%A6%93%20%E0%A6%AA%E0%A7%8D%E0%A6%B0%E0%A6%BE%E0%A6%A3%E0%A7%80');
                  },
                  'assets/e-seba-icon/agriculture.png',
                  'মৎস্য/প্রাণী',
                ),
                AllInfromationCategoryList(
                      () {
                    launch(
                        'https://www.bangladesh.gov.bd/site/view/eservices/%E0%A6%95%E0%A7%83%E0%A6%B7%E0%A6%BF');
                  },
                  'assets/e-seba-icon/planting.png',
                  "কৃষি",
                ),
                AllInfromationCategoryList(
                      () {
                    launch(
                        'https://bangladesh.gov.bd/site/view/eservices/%E0%A6%B8%E0%A7%8D%E0%A6%AC%E0%A6%BE%E0%A6%B8%E0%A7%8D%E0%A6%A5%E0%A7%8D%E0%A6%AF%20%E0%A6%AC%E0%A6%BF%E0%A6%B7%E0%A7%9F%E0%A6%95');
                  },
                  'assets/e-seba-icon/apply_education.png',
                  "স্বাস্থ্য",
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
                    launch(
                        'https://bangladesh.gov.bd/site/view/eservices/%E0%A6%AA%E0%A6%BE%E0%A6%B8%E0%A6%AA%E0%A7%8B%E0%A6%B0%E0%A7%8D%E0%A6%9F,%20%E0%A6%AD%E0%A6%BF%E0%A6%B8%E0%A6%BE%20%E0%A6%93%20%E0%A6%87%E0%A6%AE%E0%A6%BF%E0%A6%97%E0%A7%8D%E0%A6%B0%E0%A7%87%E0%A6%B6%E0%A6%A8');
                  },
                  'assets/e-seba-icon/passport_visa.png',
                  'পাসপোর্ট/ভিসা',
                ),
                AllInfromationCategoryList(
                      () {
                    launch(
                        'https://narail.police.gov.bd/');
                  },
                  'assets/e-seba-icon/law.png',
                  "নিরাপত্তা/শৃঙ্খলা",
                ),
                AllInfromationCategoryList(
                      () {
                    launch(
                        'https://www.bangladesh.gov.bd/site/view/mservices/%E0%A6%95%E0%A6%B2%20%E0%A6%B8%E0%A7%87%E0%A6%A8%E0%A7%8D%E0%A6%9F%E0%A6%BE%E0%A6%B0');
                  },
                  'assets/e-seba-icon/call.png',
                  "জরূরি কল",
                ),
                AllInfromationCategoryList(
                      () {
                    launch(
                        'https://infocom.gov.bd/site/view/law/');
                  },
                  'assets/e-seba-icon/info.png',
                  "তথ্য/আইন",
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
                    launch(
                        'https://bangladesh.gov.bd/site/view/eservices/%E0%A6%B6%E0%A6%BF%E0%A6%95%E0%A7%8D%E0%A6%B7%E0%A6%BE-%E0%A6%AC%E0%A6%BF%E0%A6%B7%E0%A7%9F%E0%A6%95');
                  },
                  'assets/e-seba-icon/apply_education.png',
                  'শিক্ষা-বিষয়ক',
                ),
                AllInfromationCategoryList(
                      () {
                    launch(
                        'https://bangladesh.gov.bd/site/view/eservices/%E0%A6%AA%E0%A6%B0%E0%A7%80%E0%A6%95%E0%A7%8D%E0%A6%B7%E0%A6%BE%E0%A6%B0%20%E0%A6%AB%E0%A6%B2%E0%A6%BE%E0%A6%AB%E0%A6%B2');
                  },
                  'assets/e-seba-icon/exam_result.png',
                  "পরীক্ষার ফলাফল",
                ),
                AllInfromationCategoryList(
                      () {
                    launch(
                        'https://bangladesh.gov.bd/site/view/eservices/%E0%A6%AD%E0%A6%B0%E0%A7%8D%E0%A6%A4%E0%A6%BF%E0%A6%B0%20%E0%A6%86%E0%A6%AC%E0%A7%87%E0%A6%A6%E0%A6%A8');
                  },
                  'assets/e-seba-icon/admission .png',
                  "ভর্তির আবেদন",
                ),
                AllInfromationCategoryList(
                      () {
                    launch(
                        'https://bangladesh.gov.bd/site/view/eservices/%E0%A6%A8%E0%A6%BF%E0%A7%9F%E0%A7%8B%E0%A6%97%20%E0%A6%B8%E0%A6%82%E0%A6%95%E0%A7%8D%E0%A6%B0%E0%A6%BE%E0%A6%A8%E0%A7%8D%E0%A6%A4');
                  },
                  'assets/e-seba-icon/govt_admision.png',
                  "নিয়োগ",
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
                    launch('https://www.narail.gov.bd/');
                  },
                  'assets/e-seba-icon/select-all.png',
                  'সমস্ত দেখুন...',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
