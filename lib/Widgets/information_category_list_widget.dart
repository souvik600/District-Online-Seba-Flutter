import 'package:flutter/material.dart';

Column AllInfromationCategoryList( btn, String image, String text) {
  return Column(
    children: [
      GestureDetector(
        onTap: btn,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                //spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      const SizedBox(height: 5),
      Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'kalpurush',
        ),
      )
    ],
  );
}
