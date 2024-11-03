import 'package:flutter/material.dart';
import '../AppColors/AppColors.dart';

Container EmergencyServiceList(inWell, String imagePath, text) {
  return Container(
    height: 110,
    decoration: const BoxDecoration(
      color: AppColors.wColor,
      boxShadow: [BoxShadow(blurRadius: 5.0, color: AppColors.bColor)],
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: inWell,
          child: Container(
            height: 76,
            width: 98,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image(
                height: 98,
                width: 75,
                fit: BoxFit.fill,
                image: AssetImage(imagePath), // Convert String to ImageProvider
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Center(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15,fontFamily: 'kalpurush'),
          ),
        ),
        const SizedBox(height: 6,),
      ],
    ),
  );
}
