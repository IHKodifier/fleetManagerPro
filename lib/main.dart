import 'package:firebase_core/firebase_core.dart';
import 'package:fleet_manager_pro/app.dart';
import 'package:fleet_manager_pro/firebase_options.dart';
// import 'package:fleet_manager_pro/onboarding.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}


