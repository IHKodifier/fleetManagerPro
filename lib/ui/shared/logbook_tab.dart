import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/maintenance_state.dart';
import 'package:fleet_manager_pro/ui/shared/maintenance_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogbookTab extends ConsumerWidget {
  late AsyncValue<List<Maintenance>> maintenanceAsync;

  late Vehicle vehicleState;
  LogbookTab({super.key});

  // Widget maintenanceCardItemBuilder(BuildContext context, int index) {
  //   // Maintenance maintenanceState = vehicle1.maintenances[index]!;
  //   // maintenanceState= vehicleState.maintenances[index]!;
  //   // return MaintenanceCard(state: maintenanceState,
  //   // totalDriven: vehicleState.driven!.toInt(),);
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    vehicleState = ref.watch(currentVehicleProvider);
    maintenanceAsync = ref.watch(maintenanceStreamProvider(vehicleState.id));

    return CustomScrollView(
      slivers: [
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
            return SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              print(
                  'length of active maintenances = ${maintenances.length.toString()}');
              final maintenance = maintenances[index];
              return MaintenanceCard(
                state: maintenance,
                totalDriven: ref.read(currentVehicleProvider).driven!,
              );
            },
            childCount: maintenances.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
