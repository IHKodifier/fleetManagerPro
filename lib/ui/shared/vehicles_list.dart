import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/states/vehicle_state.dart';
import 'package:fleet_manager_pro/ui/screens/vehicle_detail_screen.dart';
import 'package:fleet_manager_pro/ui/shared/reg_plate.dart';
import 'package:fleet_manager_pro/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:segment_display/segment_display.dart';

import '../../states/vehicle.dart';

final vehicleStreamProvider = StreamProvider<List<Vehicle>>((ref) async* {
  final user = ref.watch(appUserProvider);
  final vehiclesCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uuid)
      .collection('vehicles');
  await for (var snapshot in vehiclesCollection.snapshots()) {
    List<Vehicle> vehicles = [];
    for (var doc in snapshot.docs) {
      final vehicleData = doc.data();
      final maintenancesCount = await doc.reference
          .collection('maintenances')
          .get()
          .then((snap) => snap.size);
      final fuelstopsCount = await doc.reference
          .collection('fuelstops')
          .get()
          .then((snap) => snap.size);
      final logbookCount = await doc.reference
          .collection('logbook')
          .get()
          .then((snap) => snap.size);
      vehicleData['maintenancesCount'] = maintenancesCount;
      vehicleData['fuelstopsCount'] = fuelstopsCount;
      vehicleData['logbookCount'] = logbookCount;
      vehicles.add(Vehicle.fromMap(vehicleData));
    }
    yield vehicles;
  }
});

class VehicleList extends ConsumerWidget {
  VehicleList({super.key});

  late BuildContext _context;
  late List<Vehicle>? _data;
  late WidgetRef _ref;

  Widget error(Object error, StackTrace stackTrace) {
    print(error.toString() + stackTrace.toString());
    return SliverToBoxAdapter(child: Center(child: Text(error.toString())));
  }

  Widget loading() {
    return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()));
  }

  Widget onData(List<Vehicle> data) {
    _data = data;
    var gridDelegate = ResponsiveGridDelegate(
      // maxCrossAxisExtent: 400,
      minCrossAxisExtent: 250,
      maxCrossAxisExtent: 450,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
    );
    return SliverToBoxAdapter(
      child: Container(
        height: 900,
        child: ResponsiveGridView.builder(
            // scrollDirection: ,
            alignment: Alignment.center,
            // padding: EdgeInsets.all(8),
            itemCount: data.length,
            gridDelegate: gridDelegate,
            itemBuilder: itemBuilder),
      ),
    );
    // SliverList(
    //   delegate: SliverChildBuilderDelegate((context, index) {
    //     final thisScreen = ResponsiveBreakpoints.of(context);

    //     final e = data[index];
    // return SizedBox(
    //   width: thisScreen.screenWidth/3,
    //   child: InkWell(
    //     onTap: (){navigateToDetailsPage(e);},
    //     child: VehicleCard(context: _context, e: e),
    //   ),
    // );
    //   }, childCount: data.length),
    // ),
    // );
  }

  void navigateToDetailsPage(Vehicle e) {
    final CurrentVehicleNotifier = _ref.read(currentVehicleProvider.notifier);
    CurrentVehicleNotifier.setVehicle(e);
    Navigator.of(_context).push(
      MaterialPageRoute(
        builder: (context) => const VehicleDetailScreen(),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final e = _data![index];
    return InkWell(
      onTap: () {
        navigateToDetailsPage(e);
      },
      child: VehicleCard(context: _context, e: e),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;
    _context = context;
    final vehicles = ref.watch(vehicleStreamProvider);
    return vehicles.when(
      error: error,
      loading: loading,
      data: onData,
    );
  }
}

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required BuildContext context,
    required this.e,
  }) : _context = context;

  final Vehicle e;

  final BuildContext _context;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      autoCalculateMediaQueryData: true,
      width: 180,
      // height:100,
      child: Align(
        alignment: Alignment.center,
        child: Card(
            // margin: const EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Theme.of(_context).colorScheme.surfaceVariant,
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RegPlate(state: e),
                SizedBox(
                  child: VehicleCardTitleRow(e: e, context: _context),
                ),
                doorsAndDetailsWidget(context),
                serviceCount(context),
              ],
            )),
      ),
    );
  }

  Widget doorsAndDetailsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Gap(20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Text(
                      e.doors.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(fontSize: 8),
                    ),
                    Image.asset(
                      'assets/car-door.png',
                      width: 8,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Text(
                      e.images!.length.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(fontSize: 8),
                    ),
                    FaIcon(
                      FontAwesomeIcons.images,
                      size: 6,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Gap(20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical :8.0),
                child: Row(
                  children: [
                    Text(
                      e.maintenancesCount.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(fontSize: 8),
                    ),
                    Icon(
                      Icons.car_repair_outlined,
                      size: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Gap(20),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          
            Row(
              children: [
                Text(
                  e.fuelstopsCount.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(fontSize: 8),
                ),
                Icon(Icons.local_gas_station_rounded,
                    size: 12, color: Theme.of(context).colorScheme.primary),
              ],
            ),
           Row(children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  Utils.thousandify(
                    e.driven!,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(fontSize: 8),
                ),
              ),
              Text(
                'km',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(fontSize: 8),
              ),
            ]),
          ]),
          //  Gap(20),
        ],
      ),
    );
  }

  Widget serviceCount(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Gap(20),

            Spacer(),
            // Text(
            //   e.maintenancesCount.toString(),
            //   style:
            //       Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 8),
            // ),
            // Icon(
            //   Icons.car_repair_outlined,
            //   size: 12,
            //   color: Theme.of(context).colorScheme.primary,
            // ),
            Spacer(),
            // Text(
            //   e.fuelstopsCount.toString(),
            //   style:
            //       Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 8),
            // ),
            // Icon(Icons.local_gas_station_rounded,
            //     size: 12, color: Theme.of(context).colorScheme.primary),
            Gap(20),
          ],
        ));
  }
}

class VehicleCardTitleRow extends StatelessWidget {
  const VehicleCardTitleRow({
    super.key,
    required this.e,
    required BuildContext context,
  }) : _context = context;

  final Vehicle e;

  final BuildContext _context;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            e.year!,
            style: Theme.of(_context).textTheme.labelMedium!.copyWith(
                // textBaseline: TextBaseline.ideographic,
                fontSize: 8,
                fontStyle: FontStyle.italic),
          ),
        ),
        Text(
          e.make!,
          style: Theme.of(_context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w700,
                // fontFeatures: [Font]
                // height: 1,
              ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: [
              Text(
                e.model!,
                style: Theme.of(_context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontSize: 6),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Padding Expanded() {
  //   return Padding(
  //     padding: const EdgeInsets.all(4.0),
  //     child: Text(
  //       e.model!,
  //       style: Theme.of(_context)
  //           .textTheme
  //           .labelSmall!
  //           .copyWith(textBaseline: TextBaseline.ideographic),
  //     ),
  //   );
  // }
}
