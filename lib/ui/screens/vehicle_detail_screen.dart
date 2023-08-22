// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/vehicle.dart';
import 'package:fleet_manager_pro/ui/shared/barrel_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import '../../states/maintenance_state.dart';
import '../../states/maintenances.dart';
import '../shared/add_fuelstop_dialog.dart';
import '../shared/image_pageview.dart';
import '../shared/maintenance_card.dart';

class VehicleDetailScreen extends ConsumerStatefulWidget {
  const VehicleDetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends ConsumerState<VehicleDetailScreen> {
  List<Maintenance> activeListofMaintenances = <Maintenance>[];
  List<Maintenance> allMaintenances = <Maintenance>[];
  List<Maintenance> filteredMaintenances = <Maintenance>[];
  late final imagePageController;
  late AsyncValue<List<Maintenance>> maintenanceAsync;
  double newDriven = 0;
  late int selectedImagePage;
  bool showFuelstops = true;
  late Vehicle vehicleState;

  late BuildContext _context;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedImagePage = 0;
    imagePageController = PageController(initialPage: selectedImagePage);
    vehicleState = ref.read(currentVehicleProvider);
    newDriven = vehicleState.driven!.toDouble();
  }

  void onFABPressed() {}

  body(BuildContext context) {
    // state = ref.watch(currentVehicleProvider);
    // final pageCount = vehicleState.images!.length;
    final pageCount = ref.watch(currentVehicleProvider).images!.length;

    _context = context;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: false,
          floating: true,
          backgroundColor: Colors.transparent,
          expandedHeight: 200,
          // snap: true ,
          flexibleSpace: FlexibleSpaceBar(
              background: imagePageViewContainer(pageCount),
              collapseMode: CollapseMode.parallax,
              title: SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.background,
                          Colors.transparent,
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.center,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        Text(
                          vehicleState.reg!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    )),
              )),
          centerTitle: true,
        ),

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
                            builder: updateDrivenDialogBuilder);
                      },
                      icon: const Icon(Icons.edit))
                ],
              ),
              SwitchListTile(
                title: const Text('Show Fuels Stops'),
                value: showFuelstops,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    showFuelstops = value;

                    toggleFilters();
                  });
                },
              ),
            ],
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
            allMaintenances = List.from(maintenances);
            filteredMaintenances = List.from(allMaintenances);
            filteredMaintenances
                .removeWhere((element) => element.location == 'Fuel Station 1');
            activeListofMaintenances = allMaintenances;
            toggleFilters();
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  print(
                      'length of active maintenances = ${activeListofMaintenances.length.toString()}');
                  final maintenance = activeListofMaintenances[index];
                  return MaintenanceCard(
                    state: maintenance,
                    totalDriven: ref.read(currentVehicleProvider).driven!,
                  );
                },
                childCount: activeListofMaintenances.length,
              ),
            );
          },
        ),
        //
      ],
    );
  }

  Widget imagePageViewContainer(int pageCount) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          vehicleState.images!.isEmpty
              ? Container(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'No Media added for this car , click the camer Icon below to add Media for this car',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  )),
                )
              : imagePageView(),
          vehicleState.images!.isEmpty
              ? Container()
              : ImagePageViewDotIndicator(
                  selectedPage: selectedImagePage, pageCount: pageCount),
          Positioned(
            bottom: 8,
            left: 8,
            child: IconButton(
              icon: Icon(
                Icons.add_a_photo,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 45,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: AddMediaDialog(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PageView imagePageView() {
    return PageView(
      onPageChanged: (value) => setState(() {
        selectedImagePage = value;
      }),
      controller: imagePageController,
      children: vehicleState.images!
          .map(
            (e) => ClipRRect(
              // borderRadius: BorderRadius.circular(16),
              child: Image.network(
                fit: BoxFit.fitHeight,
                e!,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }
                },
              ),
            ),
          )
          .toList(),
    );
  }

  Widget updateDrivenDialogBuilder(BuildContext context) {
    return AlertDialog(
      title: const Text('Update  driven'),
      content: SpinBox(
        min: vehicleState.driven!.toDouble(),
        max: 2000000,
        value: newDriven,
        step: 10,
        onChanged: (value) => setState(() {
          newDriven = value;
          vehicleState = vehicleState.copyWith(driven: newDriven.toInt());
        }),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                  onPressed: () => Navigator.pop(context),
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
        const Spacer(),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  void toggleFilters() {
    if (showFuelstops) {
      setState(() {
        activeListofMaintenances = allMaintenances;
      });
    } else {
      setState(() {
        activeListofMaintenances = filteredMaintenances;
      });
    }
  }

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
    vehicleState = ref.watch(currentVehicleProvider);
    maintenanceAsync = ref.watch(maintenanceStreamProvider(vehicleState.id));
    return Scaffold(
      body: body(context),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        duration: const Duration(milliseconds: 300),
        backgroundColor: Theme.of(context).colorScheme.primary,
        fanAngle: 90,
        distance: 100,
        expandedFabSize: ExpandableFabSize.small,
        collapsedFabSize: ExpandableFabSize.regular,
        overlayStyle: ExpandableFabOverlayStyle(
          blur: 1.1,
        ),
        children: [
          FloatingActionButton(
            heroTag: 'gas',
            backgroundColor: Theme.of(context).colorScheme.primary,
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
            heroTag: 'repair',
            backgroundColor: Theme.of(context).colorScheme.primary,
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
}
