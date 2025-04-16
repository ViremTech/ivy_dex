import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ivy_dex/core/constants/color.dart';

final ThemeData darkTheme = ThemeData(
  fontFamily: 'spaceGrotesk',
  brightness: Brightness.dark,
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: kPrimaryColor,
    secondary: ksecondaryColor,
    error: kErrorColor,
  ),
  textTheme: GoogleFonts.spaceGroteskTextTheme().copyWith(
    headlineLarge: GoogleFonts.spaceGrotesk(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.spaceGrotesk(
      fontSize: 16,
      color: Colors.white,
    ),
    labelLarge: GoogleFonts.spaceGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    labelSmall: GoogleFonts.spaceGrotesk(
      fontSize: 12,
      fontWeight: FontWeight.w100,
      color: Colors.white,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  // iconTheme: const IconThemeData(color: Colors.white),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: GoogleFonts.spaceGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.w200,
      color: Colors.grey,
    ),
    filled: true,
    fillColor: const Color.fromARGB(255, 22, 22, 22),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: kErrorColor,
      ),
    ),
    focusedBorder: OutlineInputBorder(
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
    buttonColor: ksecondaryColor,
    textTheme: ButtonTextTheme.primary,
  ),
);
