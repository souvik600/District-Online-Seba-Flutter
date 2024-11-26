import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../AppColors/AppColors.dart';


class NewspaperScreen extends StatelessWidget {
  final List<Item> items = [
    Item(
      name: 'Narail Kantho',
      image: 'assets/images/narailkontho.jpg',
      url: 'https://narailkantho.com/',
    ),
    Item(
      name: 'Narail News 24',
      image: 'assets/images/NarailNews24.jpg',
      url: 'https://narailnews24.xyz/',
    ),
    Item(
      name: 'Narail SangBad',
      image: 'assets/images/narailsangbad.jpg',
      url: 'https://www.narailsangbad.xyz/',
    ),
    Item(
      name: 'Daily Ocean',
      image: 'assets/images/dailyocean.jpg',
      url: 'https://www.dainikocean.com/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pColor,
        title: const Text(
          "সংবাদপত্র",
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              fontFamily: 'kalpurush',
              color: AppColors.wColor),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.pColor.withOpacity(.2),
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          items[index].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Center(
                        child: Text(
                          items[index].name,
                          style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(AppColors.pColor),
                        ),
                        onPressed: () {
                          _launchURL(items[index].url);
                        },
                        child: const Text('সংবাদ পড়ুন..',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      // Log or show an error message
      print('Could not launch $url');
      // Optionally, show a dialog to the user
      throw 'Could not launch $url';
    }
  }
}

class Item {
  final String name;
  final String image;
  final String url;

  Item({required this.name, required this.image, required this.url});
}
