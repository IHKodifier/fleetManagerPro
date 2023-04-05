// import 'package:fleet_manager_pro/onboarding.dart';
import 'package:fleet_manager_pro/startup_view.dart';
import 'package:fleet_manager_pro/theme_data.dart';
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
      theme: appLightTheme,
      darkTheme: appDarkTheme,

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
