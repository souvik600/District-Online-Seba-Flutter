import 'package:district_online_service/AppColors/AppColors.dart';
import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserHotLineServiceScreen extends StatefulWidget {
  @override
  _UserHotLineServiceScreenState createState() =>
      _UserHotLineServiceScreenState();
}

class _UserHotLineServiceScreenState extends State<UserHotLineServiceScreen> {
  List<bool> isExpandedList =
      List.generate(hotlineData.length, (index) => false);
  List<Map<String, String>> filteredData = hotlineData;
  TextEditingController searchController = TextEditingController();

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = hotlineData;
      } else {
        filteredData = hotlineData
            .where((item) =>
                item['name']!.contains(query) ||
                item['number']!.contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("বাংলাদেশ হটলাইন সার্ভিস"),
      body: Stack(
        children: [
          ScreenBackground(context),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: searchController,
                  onChanged: filterSearchResults,
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
                  padding: const EdgeInsets.all(8),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.pColor, width: 2),
                        // Border color & width
                        borderRadius: BorderRadius.circular(
                            18), // Match Card's border radius
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Card(
                        elevation: 8,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                // Image with Opacity
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(18)),
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.1),
                                      BlendMode.darken,
                                    ),
                                    child: Image.asset(
                                      filteredData[index]['image']!,
                                      width: double.infinity,
                                      height: 120,
                                      // Increased height for better text placement
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                // Name Positioned inside Image (at bottom)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      // Dark background for readability
                                      borderRadius: const BorderRadius.vertical(
                                          bottom: Radius.circular(18)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        filteredData[index]['name']!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        filteredData[index]['number']!,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: AppColors.pColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () => launchUrl(Uri.parse(
                                            "tel://${filteredData[index]['number']}")),
                                        icon: const Icon(Icons.call,
                                            color: Colors.white),
                                        label: const Text("কল করুন"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  AnimatedCrossFade(
                                    firstChild: Text(
                                      "${(filteredData[index]['details'] ?? "").split(" ").take(10).join(" ")}...",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black54),
                                    ),
                                    secondChild: Text(
                                      filteredData[index]['details'] ?? "",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                    crossFadeState: isExpandedList[index]
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    duration: const Duration(milliseconds: 300),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          isExpandedList[index] =
                                              !isExpandedList[index];
                                        });
                                      },
                                      icon: Icon(
                                        isExpandedList[index]
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: Colors.blue,
                                      ),
                                      label: Text(
                                        isExpandedList[index]
                                            ? "সংক্ষিপ্ত করুন"
                                            : "বিস্তারিত দেখুন",
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

List<Map<String, String>> hotlineData = [
  {
    'name': 'জরুরী সেবা',
    'number': '999',
    'details': 'যেকোনো পরিস্থিতিতে এখন সবচেয়ে জরুরি নম্বর হলো ৯৯৯। এটি দেশের জাতীয় জরুরি সেবা নম্বর।'
        ' যেকোনো দুর্ঘটনার মুখোমুখি হলে জরুরি সেবা পেতে দেশের যেকোনো স্থান থেকে যে কেউ এই নম্বরে ফোন করতে পারেন।'
        ' পুলিশের অধীনে এই কল সেন্টার পরিচালিত হচ্ছে। এই নম্বরে ফোন করে পুলিশ, ফায়ার সার্ভিস ও অ্যাম্বুলেন্স সেবা'
        ' কিংবা এ–সংক্রান্ত তথ্য পাওয়া যাবে। দিনরাত ২৪ ঘণ্টা এ কল সেন্টার চালু থাকে। যেকোনো ফোন থেকে বিনা'
        ' মূল্যে ৯৯৯ নম্বরে ফোন করা যায়।',
    'image': 'assets/images/emargency.jpg',
  },
  {
    'name': 'নাগরিক তথ্য সেবা',
    'number': '333',
    'details': 'দেশের নাগরিকেরা ৩৩৩ এবং প্রবাসীরা ০৯৬৬৬৭৮৯৩৩৩ নম্বরে কল করে সরকারি সেবা প্রাপ্তির পদ্ধতি,'
        ' জনপ্রতিনিধি ও সরকারি কর্মচারীদের সঙ্গে যোগাযোগের তথ্য, বিভিন্ন এলাকার পর্যটনের স্থানসমূহ '
        'এবং বিভিন্ন জেলা সম্পর্কিত বিস্তারিত তথ্য জানতে পারবেন। সরকারি তথ্য ও সেবা সব সময়’ স্লোগান চালু '
        'হয় নতুন কল সেন্টারটি। এ ছাড়াও কল সেন্টারের মাধ্যমে বিভিন্ন সামাজিক সমস্যা সম্পর্কে প্রতিকারের জন্য জেলা '
        'প্রশাসক ও উপজেলা নির্বাহী অফিসারের কাছে তথ্য প্রদান ও অভিযোগ জানানো যাবে। দুর্যোগের সময়ে সাহায্যের জন্য'
        ' জন্য জেলা প্রশাসক ও উপজেলা নির্বাহী অফিসারের কাছে আবেদন করা যাবে এর মাধ্যমে। কল সেন্টারটি ২৪ ঘণ্টা সেবা দেবে।',
    'image': 'assets/images/info.jpg',
  },
  {
    'name': 'নারী ও শিশু নির্যাতন',
    'number': '109',
    'details': 'বাংলাদেশ সরকার ও ডেনমার্ক সরকারের যৌথ উদ্যোগে পরিচালিত মহিলা ও শিশু বিষয়ক মন্ত্রনালয়ের '
        'আধীন নারী নির্যাতন প্রতিরোধকল্পে মাল্টিসেক্টরাল প্রোগামের প্রোগ্রামের আওতায় নারী নির্যাতন '
        'প্রতিরোধে ন্যাশনাল হেল্পলাইন সেন্টার প্রতিষ্ঠা করা হয়েছে।নির্যাতনের শিকার নারী ও শিশুর প্রয়োজনীয় '
        'সকল ধরনের সেবা এবং সহায়তা প্রদান নিশ্চিতকরন।',
    'image': 'assets/images/woman.jpeg',
  },
  {
    'name': 'শিশু সহায়তা ',
    'number': '1098',
    'details': 'শিশুদের সুরক্ষায় দেশব্যাপীস সমাজকল্যাণ মন্ত্রণালয়ের সমাজসেবা অধিদফতরের অধীনে ইউনিসেফের সহায়তায় '
        'চাইল্ড হেল্পলাইন ১০৯৮ চালু হয়েছে। দেশের যেকোনো প্রান্তের কোনো শিশু কোনো ধরনের সহিংসতা,'
        ' নির্যাতন ও শোষনের শিকার হলে শিশু নিজে অথবা অন্য যে কোন ব্যক্তি বিনামূল্যে'
        ' ১০৯৮ হেল্পলাইনে ফোন করে সহায়তা চাইতে পারবেন ।',
    'image': 'assets/images/child.jpg',
  },
  {
    'name': 'জাতীয় পরিচয়পত্র',
    'number': '105',
    'details':
        'জাতীয় পরিচয়পত্র যে কোন সেবা পেতে হট লাইন ১০৫ কল করুন সাপ্তাহিক ছুটি ও অন্যান্য সরকারি ছুটি ব্যতীত সকাল ০৯:০০ ঘটিকা হতে'
            ' বিকাল ০৫.০০ ঘটিকা পর্যন্ত জাতীয় পরিচয়পত্র সম্পর্কে যে কোন ধরনের পরামর্শ হট লাইন- ১০৫ এর কার্যক্রম চলমান থাকে।',
    'image': 'assets/images/nid.png',
  },
  {
    'name': 'দূর্যোগ ও ত্রাণ  হটলাইন',
    'number': '1090',
    'details': 'দূর্যোগ ও ত্রাণ মন্ত্রণালয়ের উদ্যোগে মোবাইর ফোনের মাধ্যমে দুর্যোগের আগাম বার্তা চাহিদা মোতবেক অবহিতকরেণর '
        'জন্য টোল ফ্রি Interactive Voice Response (IVR) পদ্ধতি চালু করা হয়েছে। যে কোন মোবাইল ফোন হতে ১০৯০ টোল'
        ' ফ্রি নম্বরে ডায়াল করে ১ ডায়াল করলে সমূদ্রগামী জেলেদের জন্য আবহাওয়া বার্তা; ২ ডায়াল করলে নদী বন্দরসমূহের '
        'জন্য সতর্ক সংকেত; ৩ ডায়াল করলে দৈনন্দিন আবহাওয়া বার্তা; ৪ ডায়াল করলে ঘূর্ণিঝড়ের সতর্ক সংকেত; '
        '৫ ডায়াল করলে দেশের বন্যা তথা বিভিন্ন নদ/নদীর পানি হ্রাসবৃদ্ধি অবস্থা সম্পর্কিত তথ্য অবহিত হওয়া যাবে।',
    'image': 'assets/images/durjog.png',
  },
  {
    'name': 'দুদক হটলাইন ',
    'number': '106',
    'details': 'দুর্নীতি ও অনিয়মের তথ্য সরাসরি জানাতে  চালু হলো দুর্নীতি দমন কমিশনের (দুদক) হটলাইন ‘১০৬’। '
        'বিনা খরচে এবং যে কোন মোবাইল বা টেলিফোন থেকে এই নাম্বারে কল করে দুদককে দুর্নীতির তথ্য, '
        'অভিযোগ জানানো যাবে।অফিস চলাকালীন সকাল ৯টা থেকে বিকাল ৫টা পর্যন্ত এই নম্বরে ফ্রি কল করে দুর্নীতির তথ্য জানানো যাবে।',
    'image': 'assets/images/dudok.png',
  },
];
