import 'package:fleet_manager_pro/onboarding.dart';
import 'package:fleet_manager_pro/startup_view.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Fleet Manager Pro',
        debugShowCheckedModeBanner: false,
       
          // This is the theme of your application.
          //
       // This theme was made for FlexColorScheme version 6.1.1. Make sure
    // you use same or higher version, but still same major version. If
    // you use a lower version, some properties may not be supported. In
    // that case you can also remove them after copying the theme to your app.
    theme: FlexThemeData.light(
      scheme: FlexScheme.shark,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 9,
      appBarStyle: FlexAppBarStyle.custom,
      appBarOpacity: 0.72,
      appBarElevation: 1.5,
      tabBarStyle: FlexTabBarStyle.universal,
      surfaceTint: Color.fromARGB(255, 230, 146, 1),
      subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useFlutterDefaults: true,
      thinBorderWidth: 1.0,
      thickBorderWidth: 0.5,
      defaultRadius: 5.0,
      textButtonRadius: 20.0,
      textButtonSchemeColor: SchemeColor.tertiary,
      elevatedButtonRadius: 20.0,
      elevatedButtonSchemeColor: SchemeColor.tertiary,
      elevatedButtonSecondarySchemeColor: SchemeColor.primary,
      outlinedButtonRadius: 20.0,
      outlinedButtonSchemeColor: SchemeColor.tertiary,
      outlinedButtonOutlineSchemeColor: SchemeColor.onSecondaryContainer,
      outlinedButtonBorderWidth: 2.0,
      outlinedButtonPressedBorderWidth: 2.5,
      toggleButtonsRadius: 17.0,
      inputDecoratorSchemeColor: SchemeColor.tertiary,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorRadius: 28.0,
      inputDecoratorBorderWidth: 0.5,
      inputDecoratorFocusedBorderWidth: 2.5,
      fabUseShape: true,
      fabRadius: 55.0,
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
      tabBarIndicatorSchemeColor: SchemeColor.tertiary,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      // To use the playground font, add GoogleFonts package and uncomment
      // fontFamily: GoogleFonts.notoSans().fontFamily,
    ),
    darkTheme: FlexThemeData.dark(
      scheme: FlexScheme.shark,
      surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
      blendLevel: 22,
      tabBarStyle: FlexTabBarStyle.universal,
      darkIsTrueBlack: true,
      subThemesData: const FlexSubThemesData(
      blendOnLevel: 40,
      useFlutterDefaults: true,
      defaultRadius: 5.0,
      thinBorderWidth: 1.0,
      thickBorderWidth: 0.5,
      textButtonRadius: 20.0,
      textButtonSchemeColor: SchemeColor.tertiary,
      elevatedButtonRadius: 20.0,
      elevatedButtonSchemeColor: SchemeColor.tertiary,
      elevatedButtonSecondarySchemeColor: SchemeColor.primary,
      outlinedButtonRadius: 20.0,
      outlinedButtonSchemeColor: SchemeColor.tertiary,
      outlinedButtonOutlineSchemeColor: SchemeColor.onSecondaryContainer,
      outlinedButtonBorderWidth: 2.0,
      outlinedButtonPressedBorderWidth: 2.5,
      toggleButtonsRadius: 17.0,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorRadius: 28.0,
      inputDecoratorBorderWidth: 0.5,
      inputDecoratorFocusedBorderWidth: 2.5,
      fabUseShape: true,
      fabRadius: 55.0,
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
    
        
        home:  StartUpResolver(),
      ),
    );
  }
}