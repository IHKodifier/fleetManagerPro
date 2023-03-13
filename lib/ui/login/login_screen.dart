import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
   const LoginScreen({super.key});

  @override
 Widget build(BuildContext context,WidgetRef ref) {
   
    return  Scaffold(
      body: Center(
        // color: Colors.yellow,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment. stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // const Spacer(flex: 1,),
            Text('Please use the button below to Login ',style: Theme.of(context).textTheme.titleLarge,),
            // const Spacer(flex: 3,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton.icon(onPressed: onLoginPressed, icon: const Icon(Icons.login), label: const Text('Login'))),
            ),
            // const Spacer(),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: TextButton.icon(onPressed: onLogOutPressed, icon: const Icon(Icons.logout), label: const Text('Log out'))),
            // const Spacer(flex:3),
            Text('Powered by EnigmTek Inc',
            style: Theme.of(context).textTheme.labelSmall),
            
         
          ],
        )),
    );
  }

  void onLoginPressed() {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: 's@d.com', password: '123456');
  }

  void onLogOutPressed() {
  }
  
  
}