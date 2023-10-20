// import 'package:fleet_manager_pro/onboarding.dart';

import 'package:fleet_manager_pro/startup_view.dart';
import 'package:fleet_manager_pro/states/flexscheme_state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  final bool isDebugBannerVisible;
  const MyApp({required this.isDebugBannerVisible, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScheme = ref.watch(flexSchemeProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Fleet Manager Pro',
      debugShowCheckedModeBanner: isDebugBannerVisible,
      themeMode: themeMode,
// This theme was made for FlexColorScheme version 6.1.1. Make sure
// you use same or higher version, but still same major version. If
// you use a lower version, some properties may not be supported. In
// that case you can also remove them after copying the theme to your app.



      theme: FlexColorScheme.light(scheme: currentScheme).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: currentScheme).toTheme,

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




class AppVersionInfo {
   final version = '1.0.0';
   final release = '1.0.0';
   final build = '1.0.0';
   final poweredBy='EnigmaTek.Inc';
   final author='I H Khattak';
}

final defaultPhotoUrlProvider = Provider<String>((ref) =>'https://static.vecteezy.com/system/resources/thumbnails/001/840/618/small/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-free-vector.jpg');

final defaultBannerUrlProvider = Provider<String>((ref) =>'https://media.licdn.com/dms/image/C4D12AQHMPBvE3avWzg/article-inline_image-shrink_1000_1488/0/1616872522462?e=1693440000&v=beta&t=tgYbvrPNyIPziuAzqg_tidOVY_SEBhw6gWk9_MlbmYQ');
