
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

SvgPicture ScreenBackground(context){
  return SvgPicture.asset(
    'assets/svg_image/screen_background.svg',
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    fit: BoxFit.fill,
  );
}