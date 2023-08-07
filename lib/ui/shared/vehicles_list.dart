import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/states/vehicle_state.dart';
import 'package:fleet_manager_pro/ui/screens/vehicle_detail_screen.dart';
import 'package:fleet_manager_pro/ui/shared/reg_plate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/vehicle.dart';

final vehicleStreamProvider = StreamProvider<List<Vehicle>>((ref) async* {
  final user = ref.watch(appUserProvider);
  final vehiclesCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uuid)
      .collection('vehicles');
  yield* vehiclesCollection.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Vehicle.fromMap(doc.data())).toList());
});

class VehicleList extends ConsumerWidget {
  VehicleList({super.key});
  late WidgetRef _ref;

  late BuildContext _context;

  Widget error(Object error, StackTrace stackTrace) {
    print(error.toString() + stackTrace.toString());
    return SliverToBoxAdapter(child: Center(child: Text(error.toString())));
  }

  Widget loading() {
    return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()));
  }

  Widget data(List<Vehicle> data) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final e = data[index];
          return InkWell(
            onTap: () {
              final CurrentVehicleNotifier =
                  _ref.read(currentVehicleProvider.notifier);
              CurrentVehicleNotifier.setVehicle(e);
              Navigator.of(_context).push(MaterialPageRoute(
                  builder: (context) => const VehicleDetailScreen()));
            },
            child: Card(
                // margin: const EdgeInsets.all(8),
                color: Theme.of(_context).colorScheme.onInverseSurface,
                elevation: 5,
                // height:150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            e.make!,
                            style: Theme.of(_context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            e.model!,
                            style: Theme.of(_context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  textBaseline: TextBaseline.ideographic
                                ),
                                
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            e.year!,
                            style: Theme.of(_context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  textBaseline: TextBaseline.ideographic,
                                  fontStyle: FontStyle.italic
                                ),
                                
                          ),
                        ),
                        
                      ],
                    ),
                    RegPlate(state: e),
                  ],
                )),
          );
        }, childCount: data.length),
      ),
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
      data: data,
    );
  }
}
