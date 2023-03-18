import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../shared/app_drawer.dart';

class AppHomeScreen extends ConsumerStatefulWidget {
  const AppHomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends ConsumerState<AppHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: const CustomDrawer(),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('you have logged in'),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      onPressed: (){},
                      icon: const Icon(Icons.logout),
                      label: const Text('Log out')),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 45,
          backgroundColor: Colors.blueGrey.shade100,
          items:  const [
            BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.car,
                  // size: 50,
                ),
                label: 'cars'),
            BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.carBattery,
                  // size: 50,
                ),
                label: 'Services'),
          ],
        ),
      );
  }
}