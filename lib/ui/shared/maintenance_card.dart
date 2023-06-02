
import 'package:fleet_manager_pro/states/barrel_states.dart';

import '../../states/barrel_models.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../utils.dart';

class MaintenanceCard extends StatelessWidget {
  const MaintenanceCard({
    super.key,
    required this.maintenance, required this.totalDriven,
  });

  final Maintenance maintenance;
  final int totalDriven;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(8),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ListTile(
                //   leading: Text('${(totalDriven-maintenance.kmsDriven).toString()} Kms ago'),
                //   title: Container(width: 20,
                //     child: Column(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Text('time'),
                //       ],
                //     ),
                //   ),
                // ),
                Text('${Utils.thousandify(totalDriven-maintenance.kmsDriven) } Kms ago '),
                Text('${timeago.format(maintenance.timestamp!)} at '),
                // Spacer(),
                Text(maintenance.location!),
              ],
            ),
            ...maintenance.services!.map((e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(e!.name),
                Text(e.cost.toString()),
              ],
            ))
          ],
    
          // Add more details about the maintenance object as needed
        ),
      ),
    );
  }
}