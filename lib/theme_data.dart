import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
final appLightTheme =  FlexThemeData.light(
  scheme: FlexScheme.deepPurple,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 7,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
    blendTextTheme: true,
    // useM2StyleDividerInM3: true,
    inputDecoratorRadius: 24.0,
    fabSchemeColor: SchemeColor.primary,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);

final appDarkTheme = FlexThemeData.dark(
  scheme: FlexScheme.deepPurple,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffoldVariantDialog,
  blendLevel: 13,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    // useM2StyleDividerInM3: true,
    inputDecoratorSchemeColor: SchemeColor.primary,
    inputDecoratorRadius: 24.0,
    fabSchemeColor: SchemeColor.primary,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);

