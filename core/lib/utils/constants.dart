import 'package:flutter/material.dart';

const String BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';

const Color kRichBlack = Color(0xFF000814);
const Color kOxfordBlue = Color(0xFF001D3D);
const Color kPrussianBlue = Color(0xFF003566);
const Color kMikadoYellow = Color(0xFFffc300);
const Color kDavysGrey = Color(0xFF4B5358);
const Color kGrey = Color(0xFF303030);

const TextStyle kHeading5 = TextStyle(
  fontSize: 23,
  fontWeight: FontWeight.w400,
  fontFamily: 'Poppins',
);
const TextStyle kHeading6 = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.15,
  fontFamily: 'Poppins',
);
const TextStyle kSubtitle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.15,
  fontFamily: 'Poppins',
);
const TextStyle kBodyText = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.25,
  fontFamily: 'Poppins',
);

const kTextTheme = TextTheme(
  headlineMedium: kHeading5,
  headlineSmall: kHeading6,
  labelMedium: kSubtitle,
  bodyMedium: kBodyText,
);

const kDrawerTheme = DrawerThemeData(
  backgroundColor: Color(0xFF616161), // Colors.grey.shade700 equivalent
);

const kColorScheme = ColorScheme(
  primary: kMikadoYellow,
  secondary: kPrussianBlue,
  secondaryContainer: kPrussianBlue,
  surface: kRichBlack,
  error: Colors.red,
  onPrimary: kRichBlack,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);
