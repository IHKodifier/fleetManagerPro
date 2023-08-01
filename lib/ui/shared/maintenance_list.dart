import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/maintenances.dart';
import 'package:fleet_manager_pro/ui/shared/maintenance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/maintenance_state.dart';

class MaintenanceList extends ConsumerWidget {
  MaintenanceList({super.key, required this.vehicleId});
  var _ref;

  final String vehicleId;



  Widget onData(List<Maintenance> maintenances) {
    return ListView.builder(
      itemCount: maintenances.length,
      itemBuilder: (context, index) {
        print('length of msintenances = ${maintenances.length.toString()}');
        final maintenance = maintenances[index];
        return Container(
          // height: 150,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              // minHeight: 120,
              // maxHeight: double.infinity,
            ),
            child: MaintenanceCard(state: maintenance,
            totalDriven: _ref.read(currentVehicleProvider).driven,),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref=ref;
    final maintenanceAsync = ref.watch(maintenanceStreamProvider(vehicleId));

    return maintenanceAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text(error.toString()),
      data: onData,
    );
  }
}

