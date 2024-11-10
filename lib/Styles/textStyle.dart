import 'package:flutter/material.dart';

import '../AppColors/AppColors.dart';
TextStyle Head1Text(textColor){
  return TextStyle(
    color: textColor,
    fontSize: 28,
    fontFamily: 'poppins',
    fontWeight: FontWeight.w700,
  );
}

TextStyle Head6Text(textColor){
  return TextStyle(
      color: textColor,
      fontSize: 16,
      fontFamily: 'poppins',
      fontWeight: FontWeight.w400
  );
}
TextStyle Head7Text(textColor){
  return TextStyle(
      color: textColor,
      fontSize: 13,
      fontFamily: 'poppins',
      fontWeight: FontWeight.w400
  );
}

TextStyle Head9Text(textColor){
  return TextStyle(
      color: textColor,
      fontSize: 11,
      fontFamily: 'poppins',
      fontWeight: FontWeight.w500
  );
}
Text AppName(){
  return Text(
    "আমাদের নড়াইল",
    style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        fontFamily: 'kalpurush',
        color: AppColors.wColor),
  );

}
