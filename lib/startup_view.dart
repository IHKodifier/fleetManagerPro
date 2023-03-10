import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleet_manager_pro/onboarding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class StartUpResolver extends ConsumerWidget {
   StartUpResolver({super.key});

    final logger = Logger();
  @override
  Widget build(BuildContext context, WidgetRef ref) {

   final authState =  ref.watch(authStreamProvider);
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
    return  Container();
  }

  Widget onLoading() {
    return const CircularProgressIndicator();
  }

  Widget onData(User? user) {
    if (user==null) {
      return OnBoarding();
    } else {
      return Container(color: Colors.green,);
      
    }
  }
}



final authStreamProvider = StreamProvider<User?>((ref)  {
  final stream = FirebaseAuth.instance.authStateChanges();
  return stream;
});