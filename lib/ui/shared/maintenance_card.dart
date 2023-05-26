
import '../../states/barrel_models.dart';
import 'package:timeago/timeago.dart' as timeago;

class MaintenanceCard extends StatelessWidget {
  const MaintenanceCard({
    super.key,
    required this.maintenance,
  });

  final Maintenance maintenance;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
    );
  }
}