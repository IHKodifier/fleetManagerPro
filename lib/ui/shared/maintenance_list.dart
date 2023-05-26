import 'package:fleet_manager_pro/states/maintenances.dart';
import 'package:fleet_manager_pro/ui/shared/maintenance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../states/maintenance_state.dart';

class MaintenanceList extends ConsumerWidget {
  MaintenanceList({required this.vehicleId});

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
        final maintenance = maintenances[index];
        return MaintenanceCard(maintenance: maintenance);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenanceAsync = ref.watch(maintenanceStreamProvider(vehicleId));

    return maintenanceAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: onError,
      data: onData,
    );
  }
}

