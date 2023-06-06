import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fleet_manager_pro/ui/screens/add_maintenance_screen.dart';

import 'package:fleet_manager_pro/ui/shared/add_vehicle_form.dart';
import 'package:fleet_manager_pro/ui/shared/vehicles_list.dart';
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
  late BuildContext _context;

  List<Widget> navBarItems = [
    const FaIcon(
      FontAwesomeIcons.house,
      // color: Colors.green,
      size: 30,
    ),
    const FaIcon(
      FontAwesomeIcons.car,
      size: 30,
    ),
    const FaIcon(
      FontAwesomeIcons.carBattery,
      size: 30,
    ),
    // const FaIcon(
    //   Icons.settings,
    //   size: 30,
    // ),
    // const FaIcon(
    //   FontAwesomeIcons.message,
    //   size: 30,
    // ),
  ];
  List<Widget> appBarTitles = [
    const Text('Home'),
    const Text('MarketPlace'),
    const Text('Settings'),
    // const Text('Settings'),
    // const Text('Messages'),
  ];

  double opacity = 0;
  int pageIndex = 0;
  List<Widget> pages = [
    VehicleList(),
    Container(
      // color: Colors.red,
      child: const Text('Market Place'),
    ),
    Container(
      // color: Colors.green,
      child: const Text('Settings'),
    ),
    // Container(
    //   color: Colors.blue,
    //   child: const Text('3'),
    // ),
    // Container(
    //   color: Colors.yellow,
    //   child: const Text('4'),
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    _context = context;
    List<Widget> fabs = [
      // Container(),
      // vehicle FAB
      FloatingActionButton(
        onPressed: onVehicleAddFAB,
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: 'Add vehicle',
        child: const FaIcon(
          FontAwesomeIcons.plus,
          size: 35,
        ),
      ),
      //Maintenance FAB
      FloatingActionButton(
        onPressed: onMaintenanceAddFAB,
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: 'Add Maintennce ',
        child: const FaIcon(
          FontAwesomeIcons.plus,
          size: 35,
        ),
      ),
      Container(),
      Container(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        title: appBarTitles[pageIndex],
      ),
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers:[
         pages[pageIndex],
          SliverList(
    delegate: SliverChildListDelegate(
      [
        // Container(color: Colors.red, height: 190.0),
        // Container(color: Colors.purple, height: 150.0),
        // Container(color: Colors.green, height: 150.0),
      ],
    ),
)
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 300),
        onTap: (value) => setState(() {
          pageIndex = value;
          opacity = 1.0;
        }),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        height: 60,
        items: navBarItems,
      ),
      floatingActionButton: fabs[pageIndex],
    );
  }

  void onVehicleAddFAB() {
    Navigator.push(
        _context, MaterialPageRoute(builder: (_) => const AddVehiclePage()));
  }

  void onMaintenanceAddFAB() {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
            // actions: [ElevatedButton(onPressed: (){}, child: Text('Save'))],

            content: AddMaintenanceScreen()));
  }
}
