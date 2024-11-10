import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
        SvgPicture.asset(
        'assets/svg_image/screen_background.svg',
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
          Center(
            child: Image.asset(
              "assets/logos/logo.png",
              height: 450.0,
              width: 450.0,
            ),
          ),

          SafeArea(
            child: child!,

          ),
        ],
      ),
    );
  }
}
