import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/maintenances.dart';
import 'package:fleet_manager_pro/ui/shared/maintenance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../states/maintenance_state.dart';

class MaintenanceList extends ConsumerWidget {
  MaintenanceList({required this.vehicleId});
  var _ref;

  final String vehicleId;

  Widget onError(Object error, StackTrace stackTrace) {
  
    print(error.toString());
    print(stackTrace.toString());
    return Text('Error: $error');
  }

  Widget onData(List<Maintenance> maintenances) {
    return ListView.builder(
      itemCount: maintenances.length,
      itemBuilder: (context, index) {
        print('length of msintenances = ${maintenances.length.toString()}');
        final maintenance = maintenances[index];
        return Container(
          height: 150,
          child: MaintenanceCard(maintenance: maintenance,
          totalDriven: _ref.read(currentVehicleProvider).driven,),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref=ref;
    final maintenanceAsync = ref.watch(maintenanceStreamProvider(vehicleId));

    return maintenanceAsync.when(
      loading: () => Center(child: const CircularProgressIndicator()),
      error: onError,
      data: onData,
    );
  }
}

