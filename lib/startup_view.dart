import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleet_manager_pro/app_home_screen.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/ui/login/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class StartUpResolver extends ConsumerWidget {
   StartUpResolver({super.key});

    final logger = Logger();
  @override
  Widget build(BuildContext context, WidgetRef ref) {

   final authState =  ref.watch(authStateChangesProvider);
    return authState.when(
      error: onError, 
      loading: onLoading,
      data: onData, 
      );
  }

  Widget onError(Object error, StackTrace stackTrace) {
    if (kDebugMode){
logger.e(error.toString() + stackTrace.toString());

return Text(error.toString());
    }
    return  Center(child: Text(error.toString()),);
  }

  Widget onLoading() {
    return const CircularProgressIndicator();
  }

  Widget onData(User? user) {
    if (user==null) {

      //go to login Page
      return  const LoginScreen();
    } else {
      return const AppHomeScreen();
      
    }
  }
}



final authStreamProvider = StreamProvider<User?>((ref)  {
  final stream = FirebaseAuth.instance.authStateChanges();
  return stream;
});