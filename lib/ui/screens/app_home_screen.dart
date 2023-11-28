import 'package:fleet_manager_pro/ui/screens/add_maintenance_screen.dart';

import 'package:fleet_manager_pro/ui/shared/add_vehicle_form.dart';
import 'package:fleet_manager_pro/ui/shared/vehicles_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_framework.dart';

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

  // double opacity = 0;
  int currentPageIndex = 0;
  List<Widget> pages = [
    VehicleList(),
    SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(4),
              child: Image.asset(
                'assets/under_dev.jpg',
                height: 300,
                width: 300,
                fit: BoxFit.fitHeight,
              ),
            ),
            const Text('This feature is under development'),
          ],
        ),
      ),
    ),
    SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(4),
              child: Image.asset(
                'assets/under_dev.jpg',
                height: 300,
                width: 300,
                fit: BoxFit.fitHeight,
              ),
            ),
            const Text('This feature is under development'),
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
    List<NavigationDestination> navBarItems = [
      const NavigationDestination(
        label: 'Home',
        icon: Icon(
          Icons.home_outlined,
        ),
        selectedIcon: Icon(
          Icons.home,
         
        ),
      ),
      const NavigationDestination(
        label: 'Dashboard',
        icon: Icon(
          Icons.dashboard_outlined,
        ),
        selectedIcon: Icon(Icons.dashboard),
      ),
      const NavigationDestination(
        label: 'Marketplace',
        icon: Icon(
          Icons.shopping_cart_outlined,
          // size: 30,
        ),
        selectedIcon: Icon(
          Icons.shopping_cart,
          // size: 30,
        ) ,
      ),
    ];
    List<NavigationRailDestination> navRailItems = [
      const NavigationRailDestination(
        label: Text('Home'),
        // backgroundColor: Colors.red,
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        icon: Icon(
          Icons.home,
          // color: Theme.of(context).colorScheme.inverseSurface,
          // color: Colors.purple,
          // size: 30,
        ),
      ),
      const NavigationRailDestination(
        label: Text('Dashboard'),
        icon: Icon(
          Icons.dashboard,
          // size: 30,
        ),
      ),
      const NavigationRailDestination(
        label: Text('Marketplace'),
        icon: Icon(
          Icons.shopping_cart_outlined,
          // size: 30,
        ),
      ),
    ];

    List<Widget> fabs = [
      // Container(),
      // vehicle FAB
      FloatingActionButton(
        onPressed: onVehicleAddFAB,
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: 'Add vehicle',
        child: const FaIcon(
          FontAwesomeIcons.plus,
          // color: Theme.of(context).colorScheme.outline,
          size: 35,
        ),
      ),

      Container(),
      Container(),
    ];
final screenWidth = ResponsiveBreakpoints.of(context).screenWidth;
final isMobile = ResponsiveBreakpoints.of(context).isMobile;
final isTabet = ResponsiveBreakpoints.of(context).isTablet;
final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
final is4K = ResponsiveBreakpoints.of(context).largerThan(DESKTOP);
// final size = ResponsiveValue(context, 
// defaultValue: ,
// conditionalValues: conditionalValues);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: appBarTitles[currentPageIndex],
              floating: true,
            ),
            pages[currentPageIndex],
          ],
        ),
      ),
      bottomNavigationBar:  NavigationBar(
              animationDuration: Duration(milliseconds: 400),
              elevation: 15,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              backgroundColor: Theme.of(context).colorScheme.background,
              destinations: navBarItems,
              selectedIndex: currentPageIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
            ),
          // : null,

      // BottomNavigationBar(
      //  currentIndex: currentPageIndex,
      //  iconSize: 40,

      //  type: BottomNavigationBarType.shifting,
      //  selectedItemColor: Theme.of(context).colorScheme.primary,
      //  unselectedIconTheme: IconThemeData(
      //   color: Theme.of(context).colorScheme.primaryContainer

      //  ),
      //   onTap: (value) => setState(() {
      //     currentPageIndex = value;
      //   }),
      //   // backgroundColor: Theme.of(context).colorScheme.tertiary,
      //   items: navBarItems,
      // ),
      floatingActionButton: fabs[currentPageIndex],
    );
  }
}
