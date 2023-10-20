import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/logbook.dart';
import 'package:fleet_manager_pro/states/logbook_state.dart';
import 'package:fleet_manager_pro/ui/shared/logbook_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogbookTab extends ConsumerWidget {
  late AsyncValue<List<Logbook>> logbookAsync;

  late Vehicle vehicleState;
  LogbookTab({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    vehicleState = ref.watch(currentVehicleProvider);
    logbookAsync = ref.watch(logbookStreamProvider(vehicleState.id));

    return CustomScrollView(
      slivers: [
        logbookAsync.when(
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
          data: (logbooks) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              print(
                  'length of active maintenances = ${logbooks.length.toString()}');
              final logbook = logbooks[index];
              return LogbookCard(
                state: logbook,
                // totalDriven: ref.read(currentVehicleProvider).driven!,
              );
            },
            childCount: logbooks.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
