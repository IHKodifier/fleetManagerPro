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
  List<Widget> appBarTitles = [
    const Text('Home'),
    const Text('Dashboard'),
    const Text('MarketPlace'),
    // const Text('Settings'),
    // const Text('Messages'),
  ];

  List<Widget> navBarItems = [
    const FaIcon(
      FontAwesomeIcons.house,
      // color: Colors.green,
      size: 30,
    ),
    const Icon(
      Icons.dashboard,
      size: 30,
    ),
    const Icon(
      Icons.shopping_cart_outlined,
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

  double opacity = 0;
  int pageIndex = 0;
  List<Widget> pages = [
    VehicleList(),
    SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(4),
              child: Image.asset(
                'assets/under_dev.jpg',
                height: 300,
                width: 300,
                fit: BoxFit.fitHeight,
              ),
            ),
            Text('This feature is under development'),
          ],
        ),
      ),
    ),
SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(4),
              child: Image.asset(
                'assets/under_dev.jpg',
                height: 300,
                width: 300,
                fit: BoxFit.fitHeight,
              ),
            ),
            Text('This feature is under development'),
          ],
        ),
      ),
    ),
  ];

  late BuildContext _context;

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
        child: FaIcon(
          FontAwesomeIcons.plus,
          // color: Theme.of(context).colorScheme.outline,
          size: 35,
        ),
      ),
  
      Container(),
      Container(),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: appBarTitles[pageIndex],
              // backgroundColor: Theme.of(context).colorScheme.secondary,
              floating: true,
            ),
            pages[pageIndex],
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 300),
        onTap: (value) => setState(() {
          pageIndex = value;
          opacity = 1.0;
        }),
        backgroundColor: Theme.of(context).colorScheme.primary,
        height: 60,
        items: navBarItems,
      ),
      floatingActionButton: fabs[pageIndex],
    );
  }
}
