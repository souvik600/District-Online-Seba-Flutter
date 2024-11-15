import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
              makePhoneCall(phoneNo); // Make the phone call
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
void makePhoneCall(String phoneNo) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNo);
  if (await canLaunch(phoneUri.toString())) {
    await launch(phoneUri.toString());
  } else {
    throw 'Could not launch $phoneUri';
  }
}