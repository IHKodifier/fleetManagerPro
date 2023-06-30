import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
final appLightTheme =  FlexThemeData.light(
  scheme: FlexScheme.mango,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurfaces,
  blendLevel: 15,
  appBarStyle: FlexAppBarStyle.primary,
  appBarOpacity: 0.95,
  appBarElevation: 3,
  transparentStatusBar: true,
  tabBarStyle: FlexTabBarStyle.forAppBar,
  tooltipsMatchBackground: true,
  swapColors: false,
  lightIsWhite: false,
  // useSubThemes: true,
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  // To use playground font, add GoogleFonts package and uncomment:
  // fontFamily: GoogleFonts.notoSans().fontFamily,
  subThemesData: const FlexSubThemesData(
    useTextTheme: true,
    fabUseShape: true,
    interactionEffects: true,
    tabBarIndicatorSchemeColor: SchemeColor.secondary,
    bottomNavigationBarElevation: 0,
    bottomNavigationBarOpacity: 0.95,
    navigationBarOpacity: 0.95,
    // navigationBarMutedUnselectedText: true,
    navigationBarMutedUnselectedIcon: true,
    inputDecoratorIsFilled: true,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorUnfocusedHasBorder: false,
    blendOnColors: true,
    blendTextTheme: true,
    popupMenuOpacity: 0.95,
  ),
);

final appDarkTheme = FlexThemeData.dark(
  colors: const FlexSchemeColor(
    primary: Color(0xffc78d20),
    // primaryVariant: Color(0xffd2691e),
    secondary: Color(0xff8d9440),
    // secondaryVariant: Color(0xff616247),
    appBarColor: Color(0xff616247),
    error: Color(0xffb00020),
  ).defaultError.toDark(47),
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurfaces,
  blendLevel: 15,
  appBarStyle: FlexAppBarStyle.primary,
  appBarOpacity: 0.95,
  appBarElevation: 3,
  transparentStatusBar: true,
  tabBarStyle: FlexTabBarStyle.forAppBar,
  tooltipsMatchBackground: true,
  swapColors: true,
  darkIsTrueBlack: false,
  // useSubThemes: true,
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  // To use playground font, add GoogleFonts package and uncomment:
  // fontFamily: GoogleFonts.notoSans().fontFamily,
  subThemesData: const FlexSubThemesData(
    useTextTheme: true,
    fabUseShape: true,
    interactionEffects: true,
    tabBarIndicatorSchemeColor: SchemeColor.secondary,
    bottomNavigationBarElevation: 0,
    bottomNavigationBarOpacity: 0.95,
    navigationBarOpacity: 0.95,
    // navigationBarMutedUnselectedText: true,
    navigationBarMutedUnselectedIcon: true,
    inputDecoratorIsFilled: true,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorUnfocusedHasBorder: false,
    blendOnColors: true,
    blendTextTheme: true,
    popupMenuOpacity: 0.95,
  ),
);