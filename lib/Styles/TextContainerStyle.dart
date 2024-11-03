import 'package:flutter/material.dart';
import '../AppColors/AppColors.dart';

Container TextContainerStyle(text,color) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    // width: MediaQuery.of(context as BuildContext).size.width,
    height: 45,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color.withOpacity(.5),
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: AppColors.sdColor,
          blurRadius: 6,
          spreadRadius: 3,
          offset: Offset.infinite
        ),
      ],
    ),
    child: Text(
      text,
      style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          fontFamily: 'kalpurush'),
    ),
  );
}
