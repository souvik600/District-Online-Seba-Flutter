import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<String> loadProfileImage() async {
  User? user = FirebaseAuth.instance.currentUser;
  String profileImageUrl = '';

  if (user != null) {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      profileImageUrl = userDoc['avatar_url'] ?? ''; // Get the avatar URL
    }
  }
  return profileImageUrl;
}
//For Calling
Future<void> makeCall(String contact) async {
  final Uri launchUri = Uri(scheme: 'tel', path: contact);
  await launchUrl(launchUri);
}
// For open urls

void launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
void showCallDialog(String phoneNo, dynamic context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'Call Alert!',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ),
        content: Text(
          'অত্যাধিক প্রয়োজন ব্যাতিত এই নম্বরে কল করা থেকে বিরত থাকুন !! $phoneNo ?',
          style: const TextStyle(fontSize: 16, fontFamily: 'kalpurush'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'বিরত থাকুন',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'kalpurush',
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              makeCall(phoneNo); // Make the phone call
            },
            child: const Text(
              'ফোন করুন',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'kalpurush',
                color: Colors.green,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void sendEmail(String email, BuildContext context) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
  );

  if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri);
  } else {
    _showErrorDialog(
      context,
      'Email App Not Found',
      'It seems there is no email app installed or configured on your device.',
    );
  }
}

Future<void> launchWebsite(String url, BuildContext context) async {
  if (!url.startsWith('http')) {
    url = 'http://$url';
  }
  final Uri websiteUri = Uri.parse(url);

  if (await canLaunchUrl(websiteUri)) {
    await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
  } else {
    _showErrorDialog(
      context,
      'Website Error',
      'Could not launch the website. Please check the URL and try again.',
    );
  }
}

void _showErrorDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
