import 'package:flutter/material.dart';

import '../AppColors/AppColors.dart';

InputDecoration AppInputDecoration(label, ){
  return InputDecoration(
      focusedBorder:   OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.pColor, width: 1.5,),
        borderRadius: BorderRadius.circular(10),
      ),
      fillColor: colorLightGray,
      filled: false,
      contentPadding: EdgeInsets.fromLTRB(20, 8, 8, 20),
      enabledBorder:  OutlineInputBorder(
        borderSide:  BorderSide(color: AppColors.sColor, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),

      border: OutlineInputBorder(),
      labelText: label,
    labelStyle: const TextStyle(
    color: Colors.black38,
      fontFamily: 'poppins',
  ),
  );
}