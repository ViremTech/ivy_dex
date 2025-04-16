import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ivy_dex/core/constants/color.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: kPrimaryColor,
    secondary: ksecondaryColor,
    error: kErrorColor,
  ),
  textTheme: GoogleFonts.spaceGroteskTextTheme().copyWith(
    headlineLarge: GoogleFonts.spaceGrotesk(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.spaceGrotesk(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: GoogleFonts.spaceGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    labelSmall: GoogleFonts.spaceGrotesk(
      fontSize: 12,
      fontWeight: FontWeight.w100,
      color: Colors.black,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2C2C2C),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: kErrorColor,
      ),
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: kPrimaryColor,
        )),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: kPrimaryColor,
    textTheme: ButtonTextTheme.primary,
  ),
);
