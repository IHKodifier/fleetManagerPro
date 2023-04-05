import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

final appLightTheme = FlexThemeData.light(
  scheme: FlexScheme.vesuviusBurn,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 9,
  lightIsWhite: true,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    textButtonRadius: 2.0,
    elevatedButtonRadius: 29.0,
    elevatedButtonSchemeColor: SchemeColor.onTertiary,
    elevatedButtonSecondarySchemeColor: SchemeColor.primary,
    outlinedButtonRadius: 29.0,
    outlinedButtonSchemeColor: SchemeColor.onPrimaryContainer,
    outlinedButtonOutlineSchemeColor: SchemeColor.primary,
    outlinedButtonBorderWidth: 1.0,
    outlinedButtonPressedBorderWidth: 1.0,
    inputDecoratorSchemeColor: SchemeColor.primaryContainer,
    inputDecoratorRadius: 20.0,
    inputDecoratorBorderWidth: 2.0,
    inputDecoratorFocusedBorderWidth: 4.0,
    fabUseShape: true,
    fabAlwaysCircular: true,
    fabSchemeColor: SchemeColor.primaryContainer,
    chipSchemeColor: SchemeColor.primaryContainer,
    chipSelectedSchemeColor: SchemeColor.primaryContainer,
    chipDeleteIconSchemeColor: SchemeColor.onPrimary,
    chipRadius: 19.0,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);

final appDarkTheme = FlexThemeData.dark(
  scheme: FlexScheme.vesuviusBurn,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 15,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    textButtonRadius: 2.0,
    elevatedButtonRadius: 29.0,
    elevatedButtonSchemeColor: SchemeColor.onTertiary,
    elevatedButtonSecondarySchemeColor: SchemeColor.primary,
    outlinedButtonRadius: 29.0,
    outlinedButtonSchemeColor: SchemeColor.onPrimaryContainer,
    outlinedButtonOutlineSchemeColor: SchemeColor.primary,
    outlinedButtonBorderWidth: 1.0,
    outlinedButtonPressedBorderWidth: 1.0,
    inputDecoratorRadius: 20.0,
    inputDecoratorBorderWidth: 2.0,
    inputDecoratorFocusedBorderWidth: 4.0,
    fabUseShape: true,
    fabAlwaysCircular: true,
    fabSchemeColor: SchemeColor.primaryContainer,
    chipSchemeColor: SchemeColor.primaryContainer,
    chipSelectedSchemeColor: SchemeColor.primaryContainer,
    chipDeleteIconSchemeColor: SchemeColor.onPrimary,
    chipRadius: 19.0,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);