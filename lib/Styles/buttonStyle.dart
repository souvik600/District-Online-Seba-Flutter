import 'dart:ui';

import 'package:flutter/material.dart';
import '../AppColors/AppColors.dart';

ButtonStyle AppButtonStyle() {
  return ElevatedButton.styleFrom(
      elevation: 1,
      padding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)));
}

ButtonStyle AppStatusButtonStyle(btnColor) {
  return ElevatedButton.styleFrom(
    elevation: 1,
    padding: EdgeInsets.zero,
    backgroundColor: btnColor,
  );
}

TextStyle ButtonTextStyle() {
  return TextStyle(
      fontSize: 14, fontFamily: 'poppins', fontWeight: FontWeight.w400);
}

Ink SuccessButtonChild(String ButtonText) {
  return Ink(
    decoration: BoxDecoration(
        color: AppColors.pColor, borderRadius: BorderRadius.circular(6)),
    child: Container(
      height: 45,
      alignment: Alignment.center,
      child: Text(
        ButtonText,
        style: ButtonTextStyle(),
      ),
    ),
  );
}

class PrettyFuzzyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  PrettyFuzzyButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Blur Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0), // Increase for more blur
            child: Container(
              width: 200,
              height: 50,
              color: Colors.white.withOpacity(0.2), // Slightly transparent
            ),
          ),
          // Button Text and Functionality
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.transparent, // Text color
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
