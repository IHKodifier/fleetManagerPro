import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleet_manager_pro/ui/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppHomeScreen extends ConsumerWidget {
  const AppHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: const CustomDrawer(),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('you have logged in'),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: onLogoutPressed,
                    icon: const Icon(Icons.logout),
                    label: const Text('Log out')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onLogoutPressed() {
    FirebaseAuth.instance.signOut();
  }
}
