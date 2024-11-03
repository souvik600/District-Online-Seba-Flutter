import 'package:flutter/material.dart';
import '../AppColors/AppColors.dart';

AppBar CustomAppBar( barName){
  return AppBar(
    backgroundColor: AppColors.pColor,
    title:  Center(
      child: Text(
        barName,
        style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            fontFamily: 'kalpurush',
            color: AppColors.wColor),
      ),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20), // Adjust the radius for circular edges
      ),
    ),
  );
}


