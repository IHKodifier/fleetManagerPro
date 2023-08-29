import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/fuelstop.dart';
import 'package:fleet_manager_pro/states/fuelstop_state.dart';
import 'package:fleet_manager_pro/states/maintenance_state.dart';
import 'package:fleet_manager_pro/ui/shared/fuelstop_card.dart';
import 'package:fleet_manager_pro/ui/shared/maintenance_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FuelStopsTab extends ConsumerWidget {
  late AsyncValue<List<FuelStop>> fuelstopsAsync;

  late Vehicle vehicleState;
  FuelStopsTab({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    vehicleState = ref.watch(currentVehicleProvider);
    fuelstopsAsync = ref.watch(fuelstopStreamProvider(vehicleState.id));

    return CustomScrollView(
      slivers: [
        fuelstopsAsync.when(
          error: (error, stackTrace) {
            print(error.toString());
            print(stackTrace.toString());
            return SliverToBoxAdapter(child: Text('Error: $error'));
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
          data: (fuelstops) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              print(
                  'length of active maintenances = ${fuelstops.length.toString()}');
              final fuelstop = fuelstops[index];
              return FuelStopCard(
                state: fuelstop,
                totalDriven: ref.read(currentVehicleProvider).driven!,
              );
            },
            childCount: fuelstops.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
