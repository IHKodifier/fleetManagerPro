// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/vehicle.dart';
import 'package:fleet_manager_pro/ui/shared/add_logbook_dialog.dart';
import 'package:fleet_manager_pro/ui/shared/barrel_widgets.dart';
import 'package:fleet_manager_pro/ui/shared/fuelstops_tab.dart';
import 'package:fleet_manager_pro/ui/shared/logbook_tab.dart';
import 'package:fleet_manager_pro/ui/shared/maintenances_tab.dart';
import 'package:fleet_manager_pro/ui/shared/sliver_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import '../../states/maintenance_state.dart';
import '../../states/maintenances.dart';
import '../shared/add_fuelstop_dialog.dart';

class VehicleDetailScreen extends ConsumerStatefulWidget {
  const VehicleDetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends ConsumerState<VehicleDetailScreen>
    with TickerProviderStateMixin {
  late final imagePageController;
  late AsyncValue<List<Maintenance>> maintenanceAsync;
  double newDriven = 0;
  late int selectedImagePage;
  // late Widget tabBar;
  late Vehicle vehicleState;

  // late BuildContext _context;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vehicleState = ref.read(currentVehicleProvider);
    newDriven = vehicleState.driven!.toDouble();
  }

  void onFABPressed() {}

  Future<void> _updateDriven() async {
    if (kDebugMode) {
      print(vehicleState.driven.toString());
    }
    final vehicledocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(appUserProvider)?.uuid)
        .collection('vehicles')
        .doc(ref.read(currentVehicleProvider).id);

    await vehicledocRef
        .set({'driven': newDriven.toInt()}, SetOptions(merge: true));
    ref.read(currentVehicleProvider.notifier).updateDriven(newDriven.toInt());
    Navigator.of(context).pop();

    ref.read(currentVehicleProvider.notifier).updateDriven(newDriven.toInt());
  }

  @override
  Widget build(BuildContext context) {
    var tabs = [
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Icon(
              Icons.car_repair,
              color: Theme.of(context).colorScheme.primary,
              // size: 40,
            ),
            Text(
              'Maintances',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Icon(
              Icons.local_gas_station_rounded,
              color: Theme.of(context).colorScheme.primary,
              // size: 40,
            ),
            Text(
              'Fuel Stops',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Icon(
              Icons.location_pin,
              color: Theme.of(context).colorScheme.primary,
              // size: 40,
            ),
            Text(
              'Log Book',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    ];

    var tabViews = [
      MaintenancesTab(),
      FuelStopsTab(),
      LogbookTab(),
    ];

    vehicleState = ref.watch(currentVehicleProvider);
    maintenanceAsync = ref.watch(maintenanceStreamProvider(vehicleState.id));
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(),
          // displays the make and model of the vehicle
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // displays the make and model of th vehicle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      vehicleState.make!,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      vehicleState.model!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                // displays the year and doors of the vehicle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      vehicleState.year!,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      '${vehicleState.doors.toString()} dr',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontSize: 20),
                    ),
                  ],
                ),
                // displays the driven and button to update the driven  of the vehicle

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      vehicleState.driven.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontSize: 18),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      ' Kms',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Update  driven'),
                              content: Container(
                                width: 150,
                                height: 50,
                                child: SpinBox(
                                  min: vehicleState.driven!.toDouble(),
                                  max: 2000000,
                                  value: newDriven,
                                  step: 10,
                                  onChanged: (value) => setState(() {
                                    newDriven = value;
                                    vehicleState = vehicleState.copyWith(
                                        driven: newDriven.toInt());
                                  }),
                                ),
                              ),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      OutlinedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel')),
                                      ElevatedButton(
                                          onPressed: _updateDriven,
                                          child: const Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Text('Save'),
                                          )),
                                    ],
                                  ),
                                ),
                                // const Spacer(),
                              ],
                              actionsAlignment: MainAxisAlignment.center,
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit))
                  ],
                ),
              ],
            ),
          ),
          // SliverToBoxAdapter(child: tabBar),
          SliverFillRemaining(
            child: DefaultTabController(
              length: 3,
              child: Column(children: [
                TabBar(
                  tabs: tabs,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.primaryContainer),
                ),
                // TabBar(tabs: tabs),

                Expanded(
                  child: TabBarView(
                    children: tabViews,
                  ),
                ),
              ]),
            ),
          ),

          maintenanceAsync.when(
            error: (error, stackTrace) {
              print(error.toString());
              print(stackTrace.toString());
              return Text('Error: $error');
            },
            loading: () {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const Center(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )),
                  childCount: 4,
                ),
              );
            },
            data: (maintenances) {
              return SliverToBoxAdapter(
                  child: Container(
                height: 150,
                // color: Colors.deepOrange,
              ));
              // allMaintenances = List.from(maintenances);
              // filteredMaintenances = List.from(allMaintenances);
              // filteredMaintenances
              //     .removeWhere((element) => element.location == 'Fuel Station 1');
              // activeListofMaintenances = allMaintenances;
              // toggleFilters();
              // return SliverList(
              //   delegate: SliverChildBuilderDelegate(
              //     (context, index) {
              //       print(
              //           'length of active maintenances = ${activeListofMaintenances.length.toString()}');
              //       final maintenance = activeListofMaintenances[index];
              //       return MaintenanceCard(
              //         state: maintenance,
              //         totalDriven: ref.read(currentVehicleProvider).driven!,
              //       );
              //     },
              //     childCount: activeListofMaintenances.length,
              //   ),
              // );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        duration: const Duration(milliseconds: 150),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        fanAngle: 90,
        distance: 120,
        expandedFabSize: ExpandableFabSize.small,
        collapsedFabSize: ExpandableFabSize.regular,
        overlayStyle: ExpandableFabOverlayStyle(
          // blur: .75,
          color: Colors.black.withOpacity(0.5),
        ),
        children: [
          FloatingActionButton(
            heroTag: 'gas',
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.local_gas_station_sharp,
                size: 50,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: ((context) => const AddFuelStopDialog()),
              );
            },
          ),
          FloatingActionButton(
            heroTag: 'logbook',
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(
              Icons.mode_of_travel_rounded,
              size: 50,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const AddLogbookDialog(),
                ),
              );
            },
          ),
          FloatingActionButton(
            heroTag: 'repair',
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(
              Icons.car_repair_outlined,
              size: 50,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const AddMaintenanceScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // void updateDrivenDialogBuilder(BuildContext context) {
  //   AlertDialog(
  //     title: const Text('Update  driven'),
  //     content: SpinBox(
  //       min: vehicleState.driven!.toDouble(),
  //       max: 2000000,
  //       value: newDriven,
  //       step: 10,
  //       onChanged: (value) => setState(() {
  //         newDriven = value;
  //         vehicleState = vehicleState.copyWith(driven: newDriven.toInt());
  //       }),
  //     ),
  //     actions: [
  //       Padding(
  //         padding: const EdgeInsets.all(4.0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             OutlinedButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text('Cancel')),
  //             ElevatedButton(
  //                 onPressed: _updateDriven,
  //                 child: const Padding(
  //                   padding: EdgeInsets.all(6.0),
  //                   child: Text('Save'),
  //                 )),
  //           ],
  //         ),
  //       ),
  //       const Spacer(),
  //     ],
  //     actionsAlignment: MainAxisAlignment.center,
  //   );
  // }
}
