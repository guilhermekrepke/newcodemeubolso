import 'package:flutter/material.dart';

const kCatIcons = [Icons.restaurant_outlined, Icons.shopping_basket_outlined, Icons.directions_car_outlined, Icons.receipt_long_outlined, Icons.favorite_border, Icons.school_outlined, Icons.celebration_outlined, Icons.inventory_2_outlined];

const kBg = Color(0xFF191622), kCard = Color(0xFF202024), kPrimary = Color(0xFF8257E5), kAccent = Color(0xFF988BC7), kOk = Color(0xFF67E480), kBad = Color(0xFFF75A68), kText = Color(0xFFE1E1E6), kMuted = Color(0xFF8D8D99);

const kBig = TextStyle(fontSize: 32, fontWeight: FontWeight.bold);

final appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kBg,
  colorScheme: const ColorScheme.dark(primary: kPrimary, onPrimary: Colors.white, secondary: kAccent, secondaryContainer: Color(0xFF2A2538), onSecondaryContainer: kText, surface: kCard, onSurface: kText, error: kBad, outline: Color(0xFF3A3A44)),
  bottomSheetTheme: const BottomSheetThemeData(backgroundColor: kCard, surfaceTintColor: Colors.transparent),
);

const kGrey = TextStyle(color: kMuted);

const kBold = TextStyle(fontWeight: FontWeight.bold);

const kHeading = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
