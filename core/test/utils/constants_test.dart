import 'package:core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Constants', () {
    test('BASE_IMAGE_URL should be defined', () {
      expect(BASE_IMAGE_URL, 'https://image.tmdb.org/t/p/w500');
    });

    group('Color Constants', () {
      test('kRichBlack color should be defined', () {
        expect(kRichBlack, const Color(0xFF000814));
      });

      test('kOxfordBlue color should be defined', () {
        expect(kOxfordBlue, const Color(0xFF001D3D));
      });

      test('kPrussianBlue color should be defined', () {
        expect(kPrussianBlue, const Color(0xFF003566));
      });

      test('kMikadoYellow color should be defined', () {
        expect(kMikadoYellow, const Color(0xFFffc300));
      });

      test('kDavysGrey color should be defined', () {
        expect(kDavysGrey, const Color(0xFF4B5358));
      });

      test('kGrey color should be defined', () {
        expect(kGrey, const Color(0xFF303030));
      });
    });

    group('TextStyle Constants', () {
      test('kHeading5 should have correct properties', () {
        expect(kHeading5.fontSize, 23);
        expect(kHeading5.fontWeight, FontWeight.w400);
        expect(kHeading5.fontFamily, 'Poppins');
      });

      test('kHeading6 should have correct properties', () {
        expect(kHeading6.fontSize, 19);
        expect(kHeading6.fontWeight, FontWeight.w500);
        expect(kHeading6.letterSpacing, 0.15);
        expect(kHeading6.fontFamily, 'Poppins');
      });

      test('kSubtitle should have correct properties', () {
        expect(kSubtitle.fontSize, 15);
        expect(kSubtitle.fontWeight, FontWeight.w400);
        expect(kSubtitle.letterSpacing, 0.15);
        expect(kSubtitle.fontFamily, 'Poppins');
      });

      test('kBodyText should have correct properties', () {
        expect(kBodyText.fontSize, 13);
        expect(kBodyText.fontWeight, FontWeight.w400);
        expect(kBodyText.letterSpacing, 0.25);
        expect(kBodyText.fontFamily, 'Poppins');
      });
    });

    group('TextTheme', () {
      test('kTextTheme should have correct text styles assigned', () {
        expect(kTextTheme.headlineMedium, kHeading5);
        expect(kTextTheme.headlineSmall, kHeading6);
        expect(kTextTheme.labelMedium, kSubtitle);
        expect(kTextTheme.bodyMedium, kBodyText);
      });

      test('kTextTheme headlineMedium should have kHeading5 properties', () {
        expect(kTextTheme.headlineMedium?.fontSize, 23);
        expect(kTextTheme.headlineMedium?.fontWeight, FontWeight.w400);
        expect(kTextTheme.headlineMedium?.fontFamily, 'Poppins');
      });

      test('kTextTheme headlineSmall should have kHeading6 properties', () {
        expect(kTextTheme.headlineSmall?.fontSize, 19);
        expect(kTextTheme.headlineSmall?.fontWeight, FontWeight.w500);
        expect(kTextTheme.headlineSmall?.letterSpacing, 0.15);
        expect(kTextTheme.headlineSmall?.fontFamily, 'Poppins');
      });

      test('kTextTheme labelMedium should have kSubtitle properties', () {
        expect(kTextTheme.labelMedium?.fontSize, 15);
        expect(kTextTheme.labelMedium?.fontWeight, FontWeight.w400);
        expect(kTextTheme.labelMedium?.letterSpacing, 0.15);
        expect(kTextTheme.labelMedium?.fontFamily, 'Poppins');
      });

      test('kTextTheme bodyMedium should have kBodyText properties', () {
        expect(kTextTheme.bodyMedium?.fontSize, 13);
        expect(kTextTheme.bodyMedium?.fontWeight, FontWeight.w400);
        expect(kTextTheme.bodyMedium?.letterSpacing, 0.25);
        expect(kTextTheme.bodyMedium?.fontFamily, 'Poppins');
      });
    });

    group('DrawerTheme', () {
      test('kDrawerTheme should be defined', () {
        expect(kDrawerTheme, isNotNull);
        expect(kDrawerTheme.backgroundColor, const Color(0xFF616161));
      });
    });

    group('ColorScheme', () {
      test('kColorScheme should be defined with correct colors', () {
        expect(kColorScheme.primary, kMikadoYellow);
        expect(kColorScheme.primaryContainer, kMikadoYellow);
        expect(kColorScheme.secondary, kPrussianBlue);
        expect(kColorScheme.secondaryContainer, kPrussianBlue);
        expect(kColorScheme.surface, kRichBlack);
        expect(kColorScheme.error, Colors.red);
        expect(kColorScheme.onPrimary, kRichBlack);
        expect(kColorScheme.onSecondary, Colors.white);
        expect(kColorScheme.onSurface, Colors.white);
        expect(kColorScheme.onError, Colors.white);
        expect(kColorScheme.brightness, Brightness.dark);
      });

      test('kColorScheme primary should be kMikadoYellow', () {
        expect(kColorScheme.primary, kMikadoYellow);
      });

      test('kColorScheme secondary should be kPrussianBlue', () {
        expect(kColorScheme.secondary, kPrussianBlue);
      });

      test('kColorScheme surface should be kRichBlack', () {
        expect(kColorScheme.surface, kRichBlack);
      });

      test('kColorScheme brightness should be dark', () {
        expect(kColorScheme.brightness, Brightness.dark);
      });
    });
  });
}
