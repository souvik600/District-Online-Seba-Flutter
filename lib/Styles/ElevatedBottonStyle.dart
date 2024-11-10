import 'package:flutter/material.dart';

import '../AppColors/AppColors.dart';

class ElevatedButtonStyle extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ElevatedButtonStyle({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Full width of the parent
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pColor.withOpacity(.8),
          padding: EdgeInsets.symmetric(vertical: 12.0), // Padding for the button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w600,color: Colors.white),
        ),
      ),
    );
  }
}