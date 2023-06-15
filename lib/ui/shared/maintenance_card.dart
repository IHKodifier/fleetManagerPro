
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
      height: 85,
      width: double.infinity,
      child: Card(
        // elevation:15,
        margin: EdgeInsets.all(8),
        elevation: 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                   children: [
                     Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primary,
                          
                        ]),
                        border: Border.all(
                          color:  Theme.of(context).colorScheme.onSecondary,
                          width: 0.75,
                        ),
                      ),
                  
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Spacer(),
                            Text(Utils.thousandify(totalDriven-maintenance.kmsDriven),style: Theme.of(context).textTheme.headlineSmall),
                             Text('Kms ago',style: TextStyle(color: Colors.black,fontSize: 12),),
                            // Spacer(),
                          ],
                        ),
                      )),
                     
                   ],
                 ),
                //  Expanded(child: Container(color:Colors.red)),
                  Container(
                    child: Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4,0,4,0),
                          child: Text(maintenance.location!),
                        ),
            
            
                  Padding(
                    padding: const EdgeInsets.only(left:4.0),
                    child: Text('${timeago.format(maintenance.timestamp!)} '),
                  ),
                      ],
                    )),
                  ),
                  
                  // Spacer(),
                ],
              ),
            ),
            // ...maintenance.services!.map((e) => Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Text(e!.name),
            //     Text(e.cost.toString()),
            //   ],
            // ))
          ],
    
          // Add more details about the maintenance object as needed
        ),
      ),
    );
  }
}