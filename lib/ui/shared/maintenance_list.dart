import 'package:fleet_manager_pro/states/maintenances.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/maintenance_state.dart';

class MaintenanceList extends ConsumerWidget {
  final String vehicleId;

  MaintenanceList({required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenanceAsync = ref.watch(maintenanceStreamProvider(vehicleId));

    return maintenanceAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: onError,
      data: onData,
    );
  }

  Widget onError(Object error, StackTrace stackTrace) {
    
        print(error.toString());
        print(stackTrace.toString());
        return Text('Error: $error');
      
  }

  Widget onData(List<Maintenance> maintenances) {
    return ListView.builder(
        itemCount: maintenances.length,
        itemBuilder: (context, index) {
          final maintenance = maintenances[index];
          return ListTile(
            title: Text(maintenance.location!),
            // Add more details about the maintenance object as needed
          );
        },
      );
  }
}
