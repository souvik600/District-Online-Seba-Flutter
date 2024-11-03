import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AppColors/AppColors.dart';
import '../Styles/TextContainerStyle.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: AppColors.pColor.withOpacity(.6),
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      'assets/images/souvik_das.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Text(
                  "Developed By Souvik Das",
                  style: TextStyle(
                    color: AppColors.wColor,
                    fontFamily: 'kalpurush',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.pColor, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "আপনাদের অনলাইন সেবা কে হাতের মুঠোয় করার জন্য আমাদের এই ক্ষুদ্র প্রচেষ্টা। আশা করি সবাই আপনার প্রয়োজনীয় "
                    "মতামত দিয়ে আপনার সেবার মানতে উন্নত করার লক্ষ্যে সহায়তা করবেন। ধন্যবাদ।👏",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'kalpurush',
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextContainerStyle("Contact Me On..",AppColors.pColor),
              ListTile(
                leading: IconButton(
                  icon: Image.asset("assets/icons/whatsapp.png", height: 30, width: 30),
                  onPressed: () {
                    _launchURL('https://wa.me/+8801902200052');
                  },
                ),
                title: const Text(
                  'WhatsApp',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'kalpurush',
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  _launchURL('https://wa.me/+8801902200052');
                },
              ),
              ListTile(
                leading: IconButton(
                  icon: Image.asset("assets/icons/gmail.png", height: 20, width: 20),
                  onPressed: () {
                    _launchURL('mailto:souvikdas0600@gmail.com');
                  },
                ),
                title: const Text(
                  'Mail',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'kalpurush',
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  _launchURL('mailto:souvikdas0600@gmail.com');
                },
              ),
              ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.facebook,
                    color: Colors.blueAccent.shade700,
                    size: 30,
                  ),
                  onPressed: () {
                    _launchURL('https://www.facebook.com/profile.php?id=100050430698557');
                  },
                ),
                title: const Text(
                  'Facebook',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'kalpurush',
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  _launchURL('https://www.facebook.com/profile.php?id=100050430698557');
                },
              ),
              ListTile(
                leading: IconButton(
                  icon: Image.asset(
                    "assets/icons/linkdin.png",
                    height: 25,
                    width: 25,
                  ),
                  onPressed: () {
                    _launchURL('https://www.linkedin.com/in/souvik-das-239592250');
                  },
                ),
                title: const Text(
                  'LinkedIn',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'kalpurush',
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  _launchURL('https://www.linkedin.com/in/souvik-das-239592250');
                },
              ),
              ListTile(
                leading: IconButton(
                  icon: Image.asset(
                    "assets/icons/github.png",
                    height: 25,
                    width: 25,
                  ),
                  onPressed: () {
                    _launchURL('https://github.com/souvik600');
                  },
                ),
                title: const Text(
                  'GitHub',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'kalpurush',
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  _launchURL('https://github.com/souvik600');
                },
              ),
            ],
          ),
        ),
        // Add more list items as needed
      ],
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
