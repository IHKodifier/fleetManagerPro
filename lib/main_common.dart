import 'package:firebase_core/firebase_core.dart';
import 'package:fleet_manager_pro/environment.dart';
import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

Future<void> mainCommon(String env) async {
  //variables to hold the dev and prod version of FirebaseProject
  var devFirebase = const FirebaseOptions(
      apiKey: 'AIzaSyCJlIPYhAB2zoLZAZ2N1_rZw5Vpz2rHjbQ',
      appId: '1:315625800053:android:0e7b901b2bd5c55241533c',
      messagingSenderId: '315625800053-e2bl9icjps9169sgfufkkmogm2tlq48u.apps.googleusercontent.com',
      projectId: 'fleet-manager-pro',
      storageBucket: 'fleet-manager-pro.appspot.com');

  var prodFirebase = const FirebaseOptions(
      apiKey: 'AIzaSyBQCMjGCqbVgl6R2ojsUeE8ysBdVfcFqtQ',
      appId: '1:833775430161:android:b1e1b2876dc131496c9fb0',
      messagingSenderId: '833775430161-ln2n0d9uof9qfj146d0khgt9drarcr7k.apps.googleusercontent.com',
      projectId: 'fleet-manager-prod-86045',
      storageBucket: 'fleet-manager-prod-86045.appspot.com',
      );

  WidgetsFlutterBinding.ensureInitialized();
  //not needed anymore
  // await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 30));

  // TODO: initialize environment specfic FirebaseProject
  // Firebase.initializeApp(options: FirebaseOp);

 
  bool showDebugBanner = true;
  switch (env) {
    case Environment.dev:
      showDebugBanner = true;
      await Firebase.initializeApp(options: devFirebase);

      break;
    case Environment.prod:
      showDebugBanner = false;
            await Firebase.initializeApp(options: prodFirebase);

      break;
    default:
  }

  runApp(ProviderScope(
      child: MyApp(
    isDebugBannerVisible: showDebugBanner,
  )));
}
