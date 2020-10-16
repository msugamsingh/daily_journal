import 'package:flutter/material.dart';

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
  static List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
  static List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];
  static List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
  static List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
  static List<Color> skin = [Color(0xffff758c), Color(0xFFFCC3D9)];
  static List<Color> green = [Color(0xff1CDDAD), Color(0xFF8FE1C7)];
  static List<Color> lightG = [Colors.green, Colors.greenAccent[400]];
  static List<Color> dpurp = [Colors.deepPurpleAccent, Color(0xffff758c)];
  static List<Color> bluePurp = [Color(0xFF3B1CE4), Color(0xFFFF2AF6)];
}

class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    GradientColors(GradientColors.mango),
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.skin),
    GradientColors(GradientColors.dpurp),
    GradientColors(GradientColors.lightG),
    GradientColors(GradientColors.fire),
    GradientColors(GradientColors.green),
    GradientColors(GradientColors.bluePurp),
  ];
}

// #292D3D