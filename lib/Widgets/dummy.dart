import 'package:flutter/material.dart';
import 'package:pretty_animated_buttons/enums/slide_positions.dart';
import 'package:pretty_animated_buttons/widgets/pretty_bar_button.dart';
import 'package:pretty_animated_buttons/widgets/pretty_border_button.dart';
import 'package:pretty_animated_buttons/widgets/pretty_capsule_button.dart';
import 'package:pretty_animated_buttons/widgets/pretty_color_slide_button.dart';
import 'package:pretty_animated_buttons/widgets/pretty_fuzzy_button.dart';
import 'package:pretty_animated_buttons/widgets/pretty_neumorphic_button.dart';
import 'package:pretty_animated_buttons/widgets/pretty_shadow_button.dart';
import 'package:pretty_animated_buttons/widgets/pretty_skew_button.dart';
import 'package:pretty_animated_buttons/widgets/pretty_slide_icon_button.dart';
import 'package:pretty_animated_buttons/widgets/pretty_slide_underline_button.dart';
import 'package:pretty_animated_buttons/widgets/pretty_slide_up_button.dart';
import 'package:pretty_animated_buttons/widgets/pretty_wave_button.dart';

class PrettyButtonsExample extends StatefulWidget {
  const PrettyButtonsExample({super.key});

  @override
  State<PrettyButtonsExample> createState() => _PrettyButtonsExampleState();
}
class _PrettyButtonsExampleState extends State<PrettyButtonsExample> {
  final Color? scaffoldBg = Colors.grey[300];
  final Color btnColor = Colors.teal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Padding(
        padding: const EdgeInsets.all(
          25.0,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PrettyShadowButton(
                label: "Pretty Shadow Button",
                onPressed: () {},
                icon: Icons.arrow_forward,
                shadowColor: btnColor,
              ),
              PrettyNeumorphicButton(
                label: 'Pretty Neumorphic Button',
                onPressed: () {},
              ),
              PrettySlideUnderlineButton(
                label: 'Pretty Slide Underline Button',
                onPressed: () {},
                secondSlideColor: scaffoldBg,
              ),
              PrettyWaveButton(
                child: const Text(
                  'Pretty Wave Button',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {},
              ),
              PrettyFuzzyButton(
                label: 'Pretty Fuzzy Button',
                onPressed: () {},
              ),
              PrettySlideIconButton(
                foregroundColor: btnColor,
                icon: Icons.arrow_forward,
                label: 'Pretty Slide Icon Button',
                slidePosition: SlidePosition.right,
                labelStyle: Theme.of(context).textTheme.bodyLarge!,
                onPressed:(){},
              ),
              PrettySlideUpButton(
                bgColor: btnColor,
                onPressed:(){},
                firstChild: const Text(
                  'First Slide Up Text',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                secondChild: const Text(
                  'Second Slide Up Text',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              PrettyColorSlideButton(
                label: 'Pretty Color Slide Button',
                onPressed:(){},
                bgColor: btnColor,
                position: SlidePosition.bottom,
              ),
              PrettySkewButton(
                label: 'Pretty Skew Button',
                firstBgColor: btnColor,
                onPressed:(){},
              ),
              PrettyBorderButton(
                label: 'Pretty Border Button',
                onPressed:(){},
              ),
              PrettyBarButton(
                onPressed: () {},
                label: 'Pretty Bar Button',
              ),
              PrettyCapsuleButton(
                label: 'Pretty Capsule Button'.toUpperCase(),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                bgColor: btnColor,
                onPressed:(){},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
