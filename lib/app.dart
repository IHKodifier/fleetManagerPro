// import 'package:fleet_manager_pro/onboarding.dart';
import 'package:fleet_manager_pro/startup_view.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Fleet Manager Pro',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,

 // This theme was made for FlexColorScheme version 6.1.1. Make sure
// you use same or higher version, but still same major version. If
// you use a lower version, some properties may not be supported. In
// that case you can also remove them after copying the theme to your app.
theme: FlexThemeData.light(
  scheme: FlexScheme.espresso,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 9,
  appBarStyle: FlexAppBarStyle.custom,
  appBarElevation: 3.5,
  surfaceTint: Color(0xffff9800),
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
    useFlutterDefaults: true,
    thinBorderWidth: 1.0,
    thickBorderWidth: 0.5,
    defaultRadius: 5.0,
    textButtonRadius: 10.0,
    textButtonSchemeColor: SchemeColor.tertiary,
    elevatedButtonRadius: 10.0,
    elevatedButtonSchemeColor: SchemeColor.tertiary,
    elevatedButtonSecondarySchemeColor: SchemeColor.primary,
    outlinedButtonRadius: 10.0,
    outlinedButtonSchemeColor: SchemeColor.surfaceTint,
    outlinedButtonOutlineSchemeColor: SchemeColor.onPrimaryContainer,
    outlinedButtonBorderWidth: 1.5,
    outlinedButtonPressedBorderWidth: 1.5,
    toggleButtonsRadius: 17.0,
    inputDecoratorSchemeColor: SchemeColor.onSecondaryContainer,
    inputDecoratorRadius: 20.0,
    inputDecoratorBorderWidth: 0.5,
    inputDecoratorFocusedBorderWidth: 2.0,
    fabUseShape: true,
    fabRadius: 44.0,
    fabSchemeColor: SchemeColor.tertiary,
    chipSchemeColor: SchemeColor.tertiary,
    chipSelectedSchemeColor: SchemeColor.secondary,
    chipDeleteIconSchemeColor: SchemeColor.error,
    chipRadius: 18.0,
    cardRadius: 22.0,
    popupMenuRadius: 2.0,
    popupMenuElevation: 6.0,
    popupMenuSchemeColor: SchemeColor.onPrimary,
    popupMenuOpacity: 0.99,
    tabBarItemSchemeColor: SchemeColor.onSecondaryContainer,
    tabBarIndicatorSchemeColor: SchemeColor.tertiaryContainer,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
),
darkTheme: FlexThemeData.dark(
  scheme: FlexScheme.espresso,
  surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
  blendLevel: 22,
  darkIsTrueBlack: true,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 40,
    useFlutterDefaults: true,
    defaultRadius: 5.0,
    thinBorderWidth: 1.0,
    thickBorderWidth: 0.5,
    textButtonRadius: 10.0,
    textButtonSchemeColor: SchemeColor.tertiary,
    elevatedButtonRadius: 10.0,
    elevatedButtonSchemeColor: SchemeColor.tertiary,
    elevatedButtonSecondarySchemeColor: SchemeColor.primary,
    outlinedButtonRadius: 10.0,
    outlinedButtonSchemeColor: SchemeColor.surfaceTint,
    outlinedButtonOutlineSchemeColor: SchemeColor.onPrimaryContainer,
    outlinedButtonBorderWidth: 1.5,
    outlinedButtonPressedBorderWidth: 1.5,
    toggleButtonsRadius: 17.0,
    inputDecoratorRadius: 20.0,
    inputDecoratorBorderWidth: 0.5,
    inputDecoratorFocusedBorderWidth: 2.0,
    fabUseShape: true,
    fabRadius: 44.0,
    fabSchemeColor: SchemeColor.tertiary,
    chipSchemeColor: SchemeColor.tertiary,
    chipSelectedSchemeColor: SchemeColor.secondary,
    chipDeleteIconSchemeColor: SchemeColor.error,
    chipRadius: 18.0,
    cardRadius: 22.0,
    popupMenuRadius: 2.0,
    popupMenuElevation: 6.0,
    popupMenuSchemeColor: SchemeColor.onPrimary,
    popupMenuOpacity: 0.99,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,


      home: StartUpResolver(),
    );
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ThemeMode.light);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(super.state);

  void applyDarkTheme() {
    state = ThemeMode.dark;
  }

  void applyLightTheme() {
    state = ThemeMode.light;
  }
}
